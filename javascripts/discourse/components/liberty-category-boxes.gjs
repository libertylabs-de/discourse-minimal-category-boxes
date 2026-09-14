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

    const pathParts = this.pathname
      .replace(/^\/c\//, "")
      .split("/")
      .filter(Boolean);

    return pathParts
      .filter((part) => !/^\d+$/.test(part))
      .join("/");
  }

  get currentCategory() {
    const slugPath = this.currentSlugPath;

    if (!slugPath) {
      return null;
    }

    return this.findCategory(
      this.site.categories ?? [],
      slugPath
    );
  }

  findCategory(categories, slugPath) {
    for (const category of categories) {
      const categoryPath =
        category.fullSlug ||
        category.slugPath ||
        category.slug;

      if (
        categoryPath === slugPath ||
        category.slug === slugPath
      ) {
        return category;
      }

      const nestedCategory = this.findCategory(
        category.subcategories ?? [],
        slugPath
      );

      if (nestedCategory) {
        return nestedCategory;
      }
    }

    return null;
  }

  get subcategories() {
    return this.currentCategory?.subcategories ?? [];
  }

  get shouldDisplayHeader() {
    return Boolean(
      this.isCategoryPage &&
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
    {{else if this.shouldDisplayHeader}}
      <div
        class="liberty-category-area"
        style={{this.categoryBackgroundStyle}}
      >
        <div class="liberty-category-content">
          <LibertyCategoryHeader
            @category={{this.currentCategory}}
          />

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
