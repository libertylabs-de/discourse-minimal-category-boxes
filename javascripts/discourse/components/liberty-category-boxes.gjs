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
    return this.currentRouteName.startsWith(
      "discovery.category"
    );
  }

  // Keep your existing currentSlugPath, currentCategory,
  // subcategories, and categoryBackgroundStyle getters here.

  get shouldDisplaySubcategories() {
    return Boolean(
      this.isCategoryPage &&
        this.currentCategory?.show_subcategory_list &&
        this.subcategories.length > 0
    );
  }

  <template>
    {{!-- Deliberately empty on /categories. --}}
    {{#if this.shouldDisplaySubcategories}}
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
