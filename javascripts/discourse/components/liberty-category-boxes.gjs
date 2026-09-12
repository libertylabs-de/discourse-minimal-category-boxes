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

  get isCategoriesPage() {
    return (
      this.router.currentRouteName === "discovery.index" ||
      this.router.currentRouteName === "discovery.categories"
    );
  }

  get isCategoryPage() {
    return (
      this.router.currentRouteName === "discovery.category" ||
      this.router.currentRouteName === "discovery.subcategories"
    );
  }

  get categoryController() {
    return this.router.lookup("controller:category");
  }

  get currentCategory() {
    return this.categoryController?.category;
  }

  get subcategories() {
    return this.currentCategory?.subcategories ?? [];
  }

  get subcategoryStyle() {
    return this.currentCategory?.subcategory_list_style ?? "boxes";
  }

  get subcategoryComponent() {
    return (
      SUBCATEGORY_COMPONENTS[this.subcategoryStyle] ??
      CategoriesBoxes
    );
  }

  get shouldDisplaySubcategories() {
    return Boolean(
      this.isCategoryPage &&
        this.subcategories.length
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
        <this.subcategoryComponent
          @categories={{this.subcategories}}
        />
      </div>
    {{/if}}
  </template>
}
