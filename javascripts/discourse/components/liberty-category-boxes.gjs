import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoriesBoxes from "discourse/components/categories-boxes";
import CategoriesBoxesWithTopics from "discourse/components/categories-boxes-with-topics";
import CustomCategoryBoxes from "./custom-category-boxes";

const SUBCATEGORY_COMPONENTS = {
  boxes: CategoriesBoxes,
  boxes_with_featured_topics: CategoriesBoxesWithTopics,
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

      if (model?.slug && model?.subcategories) {
        return model;
      }

      route = route.parent;
    }

    return null;
  }

  get isCategoriesPage() {
    return (
      this.router.currentRouteName === "discovery.index" ||
      this.router.currentRouteName === "discovery.categories"
    );
  }

  get shouldDisplaySubcategories() {
    const category = this.currentCategory;

    return Boolean(
      !this.isCategoriesPage &&
        category?.show_subcategory_list &&
        category?.subcategories?.length
    );
  }

  get subcategoryComponent() {
    const style =
      this.currentCategory?.subcategory_list_style ?? "boxes";

    return SUBCATEGORY_COMPONENTS[style] ?? CategoriesBoxes;
  }

  get subcategories() {
    return this.currentCategory?.subcategories ?? [];
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
        <this.subcategoryComponent
          @categories={{this.subcategories}}
        />
      </div>
    {{/if}}
  </template>
}
