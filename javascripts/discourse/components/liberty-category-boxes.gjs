import Component from "@glimmer/component";
import { getOwner } from "@ember/application";
import { service } from "@ember/service";
import CategoriesBoxes from "discourse/components/categories-boxes";
import CategoriesBoxesWithTopics from "discourse/components/categories-boxes-with-topics";
import CustomCategoryBoxes from "./custom-category-boxes";

const SUBCATEGORY_COMPONENTS = {
  boxes: CategoriesBoxes,
  boxes_with_featured_topics: CategoriesBoxesWithTopics,
};

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

  get categoryController() {
    return getOwner(this)?.lookup("controller:category");
  }

  get currentCategory() {
    return this.categoryController?.category ?? null;
  }

  get subcategories() {
    return this.currentCategory?.subcategories ?? [];
  }

  get subcategoryStyle() {
    return (
      this.currentCategory?.subcategory_list_style ??
      "boxes"
    );
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
        <this.subcategoryComponent
          @categories={{this.subcategories}}
        />
      </div>
    {{/if}}
  </template>
}
