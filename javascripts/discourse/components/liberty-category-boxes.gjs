import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoriesBoxes from "discourse/components/categories-boxes";
import CategoriesBoxesWithTopics from "discourse/components/categories-boxes-with-topics";
import CategoriesOnly from "discourse/components/categories-only";
import CustomCategoryBoxes from "./custom-category-boxes";

const SUBCATEGORY_COMPONENTS = {
  boxes: CategoriesBoxes,
  boxes_with_featured_topics: CategoriesBoxesWithTopics,
  rows: CategoriesOnly,
  rows_with_featured_topics: CategoriesOnly,
};

export default class LibertyCategoryBoxes extends Component {
  @service site;
  @service router;

  get currentCategory() {
    let route = this.router.currentRoute;

    while (route) {
      const model = route.model;

      if (model?.category) {
        return model.category;
      }

      if (model?.parentCategory) {
        return model.parentCategory;
      }

      if (model?.subcategory) {
        return model.subcategory;
      }

      route = route.parent;
    }

    return null;
  }

  get currentSlugPath() {
    let route = this.router.currentRoute;

    while (route) {
      const rawSlugPath = route.params?.category_slug_path_with_id;

      if (typeof rawSlugPath === "string" && rawSlugPath.length > 0) {
        return rawSlugPath
          .split("/")
          .filter((part) => !/^\d+$/.test(part))
          .join("/");
      }

      route = route.parent;
    }

    return null;
  }

  get shouldDisplayGlobalBoxes() {
    const routeName = this.router.currentRouteName ?? "";

    return (
      routeName === "discovery.index" ||
      routeName === "discovery.categories"
    );
  }

  get shouldDisplaySubcategoryBoxes() {
    const category = this.currentCategory;

    if (!category) {
      return false;
    }

    return Boolean(
      category.show_subcategory_list &&
        category.subcategories?.length
    );
  }

  get subcategoryComponent() {
    const style =
      this.currentCategory?.subcategory_list_style ??
      "boxes";

    return SUBCATEGORY_COMPONENTS[style] ?? CategoriesBoxes;
  }

  get globalCategories() {
    return this.site.categories ?? [];
  }

  get subcategories() {
    return this.currentCategory?.subcategories ?? [];
  }

  get globalOutletArgs() {
    return {
      categories: this.globalCategories,
    };
  }

  <template>
    {{#if this.shouldDisplayGlobalBoxes}}
      <CustomCategoryBoxes
        @outletArgs={{this.globalOutletArgs}}
      />
    {{else if this.shouldDisplaySubcategoryBoxes}}
      <div class="custom-category-boxes-container">
        <this.subcategoryComponent
          @categories={{this.subcategories}}
        />
      </div>
    {{/if}}
  </template>
}
