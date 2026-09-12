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

      if (model?.subcategories) {
        return model;
      }

      if (model?.category_id && model?.subcategories) {
        return model;
      }

      route = route.parent;
    }

    return null;
  }

  get subcategories() {
    return this.currentCategory?.subcategories ?? [];
  }

  get subcategoryListEnabled() {
    return Boolean(
      this.currentCategory?.show_subcategory_list
    );
  }

  get subcategoryListStyle() {
    return (
      this.currentCategory?.subcategory_list_style ??
      "boxes"
    );
  }

  get shouldDisplaySubcategories() {
    return Boolean(
      this.isCategoryPage &&
        this.subcategoryListEnabled &&
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
