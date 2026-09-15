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

  get isHomepage() {
    return (
      this.pathname === "/" ||
      this.pathname === ""
    );
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

  get categoryTree() {
    return this.site.categories ?? [];
  }

  getCategoryChildren(category) {
    return (
      category?.subcategory_list ??
      category?.subcategories ??
      category?.subcategoryList ??
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
    if (!slugPath) {
      return null;
    }

    for (const category of categories ?? []) {
      if (
        this.getCategoryPath(category) === slugPath ||
        category?.slug === slugPath
      ) {
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
      this.categoryTree,
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
      categories: this.categoryTree,
    };
  }

  get categoryBackgroundUrl() {
    const category = this.currentCategory;

    return (
      category?.uploaded_background?.url ||
      category?.uploaded_background ||
      category?.background_url ||
      category?.background ||
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
    {{#if this.isHomepage}}
      <CustomCategoryBoxes
        @outletArgs={{this.globalOutletArgs}}
      />
    {{else if this.isCategoriesPage}}
      {{! Leave /categories completely untouched. }}
    {{else if this.isCategoryPage}}
      <div
        class="liberty-category-area"
        style={{this.categoryBackgroundStyle}}
      >
        <div class="liberty-category-content">
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
