import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoriesBoxes from "discourse/components/categories-boxes";
import CustomCategoryBoxes from "./custom-category-boxes";

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
        this.currentCategory &&
        this.currentCategory.show_subcategory_list &&
        this.subcategories.length > 0
    );
  }

  get globalOutletArgs() {
    return {
      categories: this.site.categories ?? [],
    };
  }

  <template>
    {{#if this.isCategoriesPage}}
      <CustomCategoryBoxes
        @outletArgs={{this.globalOutletArgs}}
      />
    {{else if this.shouldDisplaySubcategories}}
      <div class="custom-category-boxes-container">
        <CategoriesBoxes
          @categories={{this.subcategories}}
        />
      </div>
    {{/if}}
  </template>
}
