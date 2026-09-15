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

  get isOnCategoryPage() {
    return this.currentRouteName.includes("category");
  }

  get isCategoriesPage() {
    const pathname = (
      this.router.currentURL ||
      window.location.pathname ||
      ""
    ).split("?")[0];

    return (
      pathname === "/categories" ||
      pathname === "/categories/"
    );
  }

  get isHomepage() {
    const pathname = (
      this.router.currentURL ||
      window.location.pathname ||
      ""
    ).split("?")[0];

    return pathname === "/" || pathname === "";
  }

  get noneSelected() {
    return this.currentRouteName.includes("None");
  }

  get hasConfiguredSections() {
    return [
      settings.first_categories,
      settings.second_categories,
      settings.third_categories,
      settings.fourth_categories,
      settings.fifth_categories,
    ].some((value) => {
      return (
        typeof value === "string" &&
        value.trim().length > 0
      );
    });
  }

  get shouldRenderHeadings() {
    return Boolean(
      !this.isOnCategoryPage &&
        this.hasConfiguredSections
    );
  }

  categoryIds(settingValue) {
    if (
      typeof settingValue !== "string" ||
      settingValue.trim().length === 0
    ) {
      return [];
    }

    return settingValue
      .split("|")
      .map((id) => Number.parseInt(id.trim(), 10))
      .filter((id) => Number.isInteger(id));
  }

  categoriesFor(settingValue) {
    const selectedIds = this.categoryIds(settingValue);

    if (selectedIds.length === 0) {
      return [];
    }

    return this.categories.filter((category) => {
      return selectedIds.includes(Number(category.id));
    });
  }

  get firstCategories() {
    return this.categoriesFor(
      settings.first_categories
    );
  }

  get secondCategories() {
    return this.categoriesFor(
      settings.second_categories
    );
  }

  get thirdCategories() {
    return this.categoriesFor(
      settings.third_categories
    );
  }

  get fourthCategories() {
    return this.categoriesFor(
      settings.fourth_categories
    );
  }

  get fifthCategories() {
    return this.categoriesFor(
      settings.fifth_categories
    );
  }

  get firstHeader() {
    return settings.first_categories_header;
  }

  get secondHeader() {
    return settings.second_categories_header;
  }

  get thirdHeader() {
    return settings.third_categories_header;
  }

  get fourthHeader() {
    return settings.fourth_categories_header;
  }

  get fifthHeader() {
    return settings.fifth_categories_header;
  }

  <template>
    <div class={{this.classNames}}>
      {{#if this.shouldRenderHeadings}}
        {{#if this.firstCategories.length}}
          {{#if this.firstHeader}}
            <CategoryHeader
              @header={{this.firstHeader}}
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
          Homepage fallback:
          if no section settings are configured, render all categories.
          Once any section is configured, only the selected sections render.
        --}}
        <CategoryBoxes
          @categories={{this.categories}}
        />
      {{/if}}
    </div>
  </template>
}
