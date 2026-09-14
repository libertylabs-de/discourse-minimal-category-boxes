import Component from "@glimmer/component";
import { service } from "@ember/service";

import CategoryLogo from "discourse/components/category-logo";
import CategoryTitleBefore from "discourse/components/category-title-before";

export default class LibertyCategoryHeader extends Component {
  @service router;
  @service site;

  get currentUrl() {
    return (
      this.router.currentURL ||
      window.location.pathname ||
      ""
    );
  }

  get pathname() {
    return this.currentUrl.split("?")[0];
  }

  get isCategoryPage() {
    return (
      this.pathname === "/c" ||
      this.pathname.startsWith("/c/")
    );
  }

  get currentSlugPath() {
    if (!this.isCategoryPage) {
      return null;
    }

    return this.pathname
      .replace(/^\/c\//, "")
      .split("/")
      .filter(Boolean)
      .filter((part) => !/^\d+$/.test(part))
      .join("/");
  }

  findCategory(categories, slugPath) {
    for (const category of categories ?? []) {
      const categorySlugPath =
        category.fullSlug ||
        category.slugPath ||
        category.slug;

      if (
        categorySlugPath === slugPath ||
        category.slug === slugPath
      ) {
        return category;
      }

      const nestedCategory = this.findCategory(
        category.subcategories,
        slugPath
      );

      if (nestedCategory) {
        return nestedCategory;
      }
    }

    return null;
  }

  get category() {
    return this.findCategory(
      this.site.categories ?? [],
      this.currentSlugPath
    );
  }

  get shouldDisplay() {
    return Boolean(
      this.isCategoryPage &&
        this.category
    );
  }

  get categoryLogoUrl() {
    return (
      this.category?.uploaded_logo?.url ||
      this.category?.uploaded_logo ||
      null
    );
  }

  <template>
    {{#if this.shouldDisplay}}
      <div class="liberty-category-header-inner">
        <div class="liberty-category-header-title">
          <h1>
            <CategoryTitleBefore
              @category={{this.category}}
            />
            {{this.category.name}}
          </h1>

          {{#if this.category.description_excerpt}}
            <p>
              {{this.category.description_excerpt}}
            </p>
          {{/if}}
        </div>

        {{#if this.categoryLogoUrl}}
          <CategoryLogo
            @category={{this.category}}
          />
        {{/if}}
      </div>
    {{/if}}
  </template>
}
