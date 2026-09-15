import Component from "@glimmer/component";
import { service } from "@ember/service";

import CategoryBoxes from "./category-boxes";
import CategoryHeader from "./category-header";

export default class CustomCategoryBoxes extends Component {
  @service router;
  @service site;

  get classNames() {
    const classes = [
      "custom-category-boxes-container",
    ];

    if (this.noneSelected) {
      classes.push("none-selected");
    }

    return classes.join(" ");
  }

  get categories() {
    return (
      this.args.outletArgs?.categories ??
      this.site.categories ??
      []
    );
  }

  get currentRouteName() {
    return (
      this.router.currentRouteName ||
      this.router.currentRoute?.name ||
      ""
    );
  }

  get currentPathname() {
    return (
      this.router.currentURL ||
      window.location.pathname ||
      ""
    ).split("?")[0];
  }

  get isOnCategoryPage() {
    return (
      this.currentPathname === "/c" ||
      this.currentPathname.startsWith("/c/")
    );
  }

  get isHomepage() {
    return (
      this.currentPathname === "/" ||
      this.currentPathname === ""
    );
  }

  get noneSelected() {
    return this.currentRouteName.includes("None");
  }

  getSettingValue(name) {
    return settings?.[name];
  }

  categoryIds(value) {
    if (Array.isArray(value)) {
      return value
        .map((id) => Number.parseInt(id, 10))
        .filter((id) => Number.isInteger(id));
    }

    if (typeof value !== "string") {
      return [];
    }

    const normalized = value.trim();

    if (!normalized) {
      return [];
    }

    /*
     * Discourse list settings normally use "|".
     * The comma fallback supports older/string-based settings.
     */
    const separator = normalized.includes("|")
      ? "|"
      : ",";

    return normalized
      .split(separator)
      .map((id) => Number.parseInt(id.trim(), 10))
      .filter((id) => Number.isInteger(id));
  }

  categoriesFor(settingName) {
    const selectedIds = this.categoryIds(
      this.getSettingValue(settingName)
    );

    if (selectedIds.length === 0) {
      return [];
    }

    return this.categories.filter((category) => {
      return selectedIds.includes(Number(category.id));
    });
  }

  get firstCategories() {
    return this.categoriesFor("first_categories");
  }

  get secondCategories() {
    return this.categoriesFor("second_categories");
  }

  get thirdCategories() {
    return this.categoriesFor("third_categories");
  }

  get fourthCategories() {
    return this.categoriesFor("fourth_categories");
  }

  get fifthCategories() {
    return this.categoriesFor("fifth_categories");
  }

  get firstHeader() {
    return this.getSettingValue(
      "first_categories_header"
    );
  }

  get secondHeader() {
    return this.getSettingValue(
      "second_categories_header"
    );
  }

  get thirdHeader() {
    return this.getSettingValue(
      "third_categories_header"
    );
  }

  get fourthHeader() {
    return this.getSettingValue(
      "fourth_categories_header"
    );
  }

  get fifthHeader() {
    return this.getSettingValue(
      "fifth_categories_header"
    );
  }

  get hasConfiguredSections() {
    return [
      this.firstCategories,
      this.secondCategories,
      this.thirdCategories,
      this.fourthCategories,
      this.fifthCategories,
    ].some((categories) => {
      return categories.length > 0;
    });
  }

  get shouldRenderHeadings() {
    return Boolean(
      this.isHomepage &&
        this.hasConfiguredSections
    );
  }

  <template>
    <div class={{this.classNames}}>
      {{#if this.shouldRenderHeadings}}
        {{#if this.firstCategories.length}}
          {{#if this.firstHeader}}
            <CategoryHeader
              @header={{this.firstHeader}}
              @className="custom-category-header-first"
            />
          {{/if}}

          <CategoryBoxes
            @categories={{this.firstCategories}}
          />
        {{/if}}

        {{#if this.secondCategories.length}}
          {{#if this.secondHeader}}
            <CategoryHeader
              @header={{this.secondHeader}}
            />
          {{/if}}

          <CategoryBoxes
            @categories={{this.secondCategories}}
          />
        {{/if}}

        {{#if this.thirdCategories.length}}
          {{#if this.thirdHeader}}
            <CategoryHeader
              @header={{this.thirdHeader}}
            />
          {{/if}}

          <CategoryBoxes
            @categories={{this.thirdCategories}}
          />
        {{/if}}

        {{#if this.fourthCategories.length}}
          {{#if this.fourthHeader}}
            <CategoryHeader
              @header={{this.fourthHeader}}
            />
          {{/if}}

          <CategoryBoxes
            @categories={{this.fourthCategories}}
          />
        {{/if}}

        {{#if this.fifthCategories.length}}
          {{#if this.fifthHeader}}
            <CategoryHeader
              @header={{this.fifthHeader}}
            />
          {{/if}}

          <CategoryBoxes
            @categories={{this.fifthCategories}}
          />
        {{/if}}
      {{else if this.isHomepage}}
        {{!--
          Fallback only when no configured section has any valid IDs.
        --}}
        <CategoryBoxes
          @categories={{this.categories}}
        />
      {{/if}}
    </div>
  </template>
}
