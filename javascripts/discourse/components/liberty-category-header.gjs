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

  getCategoryChildren(category) {
    return (
      category?.subcategory_list ??
      category?.subcategories ??
      []
    );
  }

  getCategoryPath(category) {
    return (
      category?.full_slug ||
      category?.fullSlug ||
      category?.slug_path ||
      category?.slugPath ||
      category?.slug ||
      ""
    );
  }

  findCategory(categories, slugPath) {
    if (!slugPath) {
      return null;
    }

    for (const category of categories ?? []) {
      const categoryPath =
        this.getCategoryPath(category);

      if (categoryPath === slugPath) {
        return category;
      }

      const nestedCategory = this.findCategory(
        this.getCategoryChildren(category),
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
