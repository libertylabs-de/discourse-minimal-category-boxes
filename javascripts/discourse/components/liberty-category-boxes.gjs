import Component from "@glimmer/component";
import { service } from "@ember/service";

import CategoryBoxes from "./category-boxes";
import CustomCategoryBoxes from "./custom-category-boxes";
import LibertyCategoryHeader from "./liberty-category-header";

export default class LibertyCategoryBoxes extends Component {
  @service router;
  @service site;

  get currentRouteName() {
    return this.router.currentRouteName ?? "";
  }

  get isCategoriesPage() {
    return (
      this.currentRouteName === "discovery.index" ||
      this.currentRouteName === "discovery.categories"
    );
  }

  get isCategoryPage() {
    return (
      this.currentRouteName === "discovery.category" ||
      this.currentRouteName === "discovery.subcategories"
    );
  }

  get currentSlugPath() {
    let route = this.router.currentRoute;

    while (route) {
      const rawSlugPath =
        route.params?.category_slug_path_with_id;

      if (
        typeof rawSlugPath === "string" &&
        rawSlugPath.length > 0
      ) {
        return rawSlugPath
          .split("/")
          .filter((part) => !/^\d+$/.test(part))
          .join("/");
      }

      route = route.parent;
    }

    return null;
  }

  get currentCategory() {
    const slugPath = this.currentSlugPath;

    if (!slugPath) {
      return null;
    }

    const categories = this.site.categories ?? [];

    return (
      categories.find((category) => {
        return (
          category.slug === slugPath ||
          category.fullSlug === slugPath ||
          category.slugPath === slugPath
        );
      }) ?? null
    );
  }

  get subcategories() {
    return this.currentCategory?.subcategories ?? [];
  }

  get shouldDisplaySubcategories() {
    return Boolean(
      this.isCategoryPage &&
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

    const escapedUrl = url.replace(/"/g, '\\"');

    return `--liberty-category-background: url("${escapedUrl}")`;
  }

  <template>
    {{!--
      /categories and the site homepage category route:
      render the complete custom category list below the site header.
    --}}
    {{#if this.isCategoriesPage}}
      <CustomCategoryBoxes
        @outletArgs={{this.globalOutletArgs}}
      />

    {{!--
      /c/... and subcategory routes:
      render the current category header and its subcategories
      below the site header.
    --}}
    {{else if this.shouldDisplaySubcategories}}
      <div
        class="liberty-category-area"
        style={{this.categoryBackgroundStyle}}
      >
        <div class="liberty-category-content">
          <LibertyCategoryHeader
            @category={{this.currentCategory}}
          />

          <div class="custom-category-boxes-container">
            <CategoryBoxes
              @categories={{this.subcategories}}
            />
          </div>
        </div>
      </div>
    {{/if}}
  </template>
}
