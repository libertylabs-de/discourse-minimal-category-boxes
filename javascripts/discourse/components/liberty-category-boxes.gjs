import Component from "@glimmer/component";
import { service } from "@ember/service";

import CategoryBoxes from "./category-boxes";
import CustomCategoryBoxes from "./custom-category-boxes";
import LibertyCategoryHeader from "./liberty-category-header";

export default class LibertyCategoryBoxes extends Component {
  @service router;
  @service site;

  get currentUrl() {
    return (
      this.router.currentURL ||
      window.location.pathname ||
      ""
    );
  }

  get pathname() {
    return this.currentUrl.split("?")[0];
  }

  get isCategoriesPage() {
    return (
      this.pathname === "/categories" ||
      this.pathname === "/categories/"
    );
  }

  get isCategoryPage() {
    return (
      this.pathname === "/c" ||
      this.pathname.startsWith("/c/")
    );
  }

  get currentSlugPath() {
    if (!this.isCategoryPage) {
      return null;
    }

    return this.pathname
      .replace(/^\/c\//, "")
      .split("/")
      .filter(Boolean)
      .filter((part) => !/^\d+$/.test(part))
      .join("/");
  }

  getCategoryChildren(category) {
    return (
      category?.subcategory_list ??
      category?.subcategories ??
      []
    );
  }

  getCategoryPath(category) {
    return (
      category?.full_slug ||
      category?.fullSlug ||
      category?.slug_path ||
      category?.slugPath ||
      category?.slug ||
      ""
    );
  }

  findCategory(categories, slugPath) {
    for (const category of categories ?? []) {
      if (this.getCategoryPath(category) === slugPath) {
        return category;
      }

      const nestedCategory = this.findCategory(
        this.getCategoryChildren(category),
        slugPath
      );

      if (nestedCategory) {
        return nestedCategory;
      }
    }

    return null;
  }

  get currentCategory() {
    return this.findCategory(
      this.site.categories ?? [],
      this.currentSlugPath
    );
  }

  get subcategories() {
    return this.getCategoryChildren(
      this.currentCategory
    );
  }

  get shouldDisplaySubcategories() {
    return Boolean(
      this.currentCategory?.show_subcategory_list &&
        this.subcategories.length > 0
    );
  }

  get globalOutletArgs() {
    return {
      categories: this.site.categories ?? [],
    };
  }

  get categoryBackgroundUrl() {
    const category = this.currentCategory;

    return (
      category?.uploaded_background?.url ||
      category?.uploaded_background ||
      category?.background_url ||
      null
    );
  }

  get categoryBackgroundStyle() {
    const url = this.categoryBackgroundUrl;

    if (!url) {
      return null;
    }

    const escapedUrl = url
      .replace(/\\/g, "\\\\")
      .replace(/"/g, '\\"');

    return `--liberty-category-background: url("${escapedUrl}")`;
  }

  <template>
    {{#if this.isCategoriesPage}}
      <CustomCategoryBoxes
        @outletArgs={{this.globalOutletArgs}}
      />
    {{else if this.isCategoryPage}}
      <div
        class="liberty-category-area"
        style={{this.categoryBackgroundStyle}}
      >
        <div class="liberty-category-content">
          <div
            style="
              background: yellow;
              color: black;
              padding: 1rem;
            "
          >
            LibertyCategoryBoxes is rendering.
            URL: {{this.pathname}}
            SLUG: {{this.currentSlugPath}}
          </div>

          <LibertyCategoryHeader />

          {{#if this.shouldDisplaySubcategories}}
            <div class="custom-category-boxes-container">
              <CategoryBoxes
                @categories={{this.subcategories}}
              />
            </div>
          {{/if}}
        </div>
      </div>
    {{/if}}
  </template>
}
