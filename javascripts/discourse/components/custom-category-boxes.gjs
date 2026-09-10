import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoryBoxes from "./category-boxes";
import CategoryHeader from "./category-header";

export default class extends Component {
  @service router;
  @service site;

  get classNames() {
    const classNames = ["custom-category-boxes-container"];
    if (this.noneSelected) {
      classNames.push("none-selected");
    }
    return classNames.join(" ");
  }

  #allowedCategories(selectedCategories) {
    if (!selectedCategories || selectedCategories.length === 0) return [];
    return this.site.categories.filter(
      (category) => selectedCategories.indexOf(category.id) !== -1
    );
  }

  get isOnCategoryPage() {
    return this.router.currentRoute?.name?.includes("category") ?? false;
  }

  get hasAnySectionConfigured() {
    return (
      settings.first_categories ||
      settings.second_categories ||
      settings.third_categories ||
      settings.fourth_categories ||
      settings.fifth_categories
    );
  }

  get shouldRenderHeadings() {
    return !!this.hasAnySectionConfigured && !this.isOnCategoryPage;
  }

  get fallbackCategories() {
    return this.args.outletArgs?.categories ?? this.site.categories;
  }

  get noneSelected() {
    return this.router.currentRoute?.name?.includes("None") ?? false;
  }

  get firstCategories() {
    const raw = settings.first_categories;
    if (!raw) return [];
    return this.#allowedCategories(raw.split("|").map((id) => Number(id)));
  }

  get secondCategories() {
    const raw = settings.second_categories;
    if (!raw) return [];
    return this.#allowedCategories(raw.split("|").map((id) => Number(id)));
  }

  get thirdCategories() {
    const raw = settings.third_categories;
    if (!raw) return [];
    return this.#allowedCategories(raw.split("|").map((id) => Number(id)));
  }

  get fourthCategories() {
    const raw = settings.fourth_categories;
    if (!raw) return [];
    return this.#allowedCategories(raw.split("|").map((id) => Number(id)));
  }

  get fifthCategories() {
    const raw = settings.fifth_categories;
    if (!raw) return [];
    return this.#allowedCategories(raw.split("|").map((id) => Number(id)));
  }

  <template>
    <div class={{this.classNames}}>
      {{#if this.shouldRenderHeadings}}

        {{#if this.firstCategories.length}}
          <CategoryHeader @header={{settings.first_categories_header}} />
          <CategoryBoxes @categories={{this.firstCategories}} />
        {{/if}}

        {{#if this.secondCategories.length}}
          <CategoryHeader @header={{settings.second_categories_header}} />
          <CategoryBoxes @categories={{this.secondCategories}} />
        {{/if}}

        {{#if this.thirdCategories.length}}
          <CategoryHeader @header={{settings.third_categories_header}} />
          <CategoryBoxes @categories={{this.thirdCategories}} />
        {{/if}}

        {{#if this.fourthCategories.length}}
          <CategoryHeader @header={{settings.fourth_categories_header}} />
          <CategoryBoxes @categories={{this.fourthCategories}} />
        {{/if}}

        {{#if this.fifthCategories.length}}
          <CategoryHeader @header={{settings.fifth_categories_header}} />
          <CategoryBoxes @categories={{this.fifthCategories}} />
        {{/if}}

      {{else}}
        {{! Fallback: render all categories without section headings }}
        <CategoryBoxes @categories={{this.fallbackCategories}} />
      {{/if}}
    </div>
  </template>
}
