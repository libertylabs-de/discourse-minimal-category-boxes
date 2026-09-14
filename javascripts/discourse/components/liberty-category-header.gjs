import Component from "@glimmer/component";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";

import CategoryLogo from "discourse/components/category-logo";
import CategoryTitleBefore from "discourse/components/category-title-before";

export default class LibertyCategoryHeader extends Component {
  @service router;

  @tracked category = null;
  @tracked loading = false;

  loadedCategoryId = null;
  loadingCategoryId = null;

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

  get categoryId() {
    if (!this.isCategoryPage) {
      return null;
    }

    const parts = this.pathname
      .split("/")
      .filter(Boolean);

    const lastPart = parts.at(-1);

    return /^\d+$/.test(lastPart)
      ? lastPart
      : null;
  }

  get categoryUrlKey() {
    return this.categoryId || this.pathname;
  }

  get shouldLoadCategory() {
    return Boolean(
      this.isCategoryPage &&
        this.categoryId &&
        this.loadedCategoryId !== this.categoryId &&
        this.loadingCategoryId !== this.categoryId
    );
  }

  loadCategoryIfNeeded() {
    if (!this.shouldLoadCategory) {
      return;
    }

    const categoryId = this.categoryId;

    this.loadingCategoryId = categoryId;
    this.loading = true;
    this.category = null;

    ajax(`/c/${categoryId}/show.json`)
      .then((response) => {
        if (this.categoryId !== categoryId) {
          return;
        }

        this.category =
          response.category ||
          response;

        this.loadedCategoryId = categoryId;
      })
      .catch((error) => {
        if (this.categoryId === categoryId) {
          this.category = null;
          this.loadedCategoryId = null;
        }

        console.error(
          "[LibertyCategoryHeader] Failed to load category:",
          error
        );
      })
      .finally(() => {
        if (this.loadingCategoryId === categoryId) {
          this.loadingCategoryId = null;
          this.loading = false;
        }
      });
  }

  get categoryLogoUrl() {
    return (
      this.category?.uploaded_logo?.url ||
      this.category?.uploaded_logo ||
      null
    );
  }

  get categoryBackgroundUrl() {
    return (
      this.category?.uploaded_background?.url ||
      this.category?.uploaded_background ||
      this.category?.background_url ||
      null
    );
  }

  get categoryBackgroundStyle() {
    const url = this.categoryBackgroundUrl;

    if (!url) {
      return null;
    }

    const escapedUrl = url
      .replace(/\\/g, "\\\\")
      .replace(/"/g, '\\"');

    return `--liberty-category-background: url("${escapedUrl}")`;
  }

  get displayCategory() {
    this.loadCategoryIfNeeded();

    return this.category;
  }

  <template>
    {{#if this.isCategoryPage}}
      {{#if this.displayCategory}}
        <div
          class="liberty-category-header-inner"
          style={{this.categoryBackgroundStyle}}
        >
          <div class="liberty-category-header-title">
            <h1>
              <CategoryTitleBefore
                @category={{this.displayCategory}}
              />
              {{this.displayCategory.name}}
            </h1>

            {{#if this.displayCategory.description_excerpt}}
              <p>
                {{this.displayCategory.description_excerpt}}
              </p>
            {{/if}}
          </div>

          {{#if this.categoryLogoUrl}}
            <CategoryLogo
              @category={{this.displayCategory}}
            />
          {{/if}}
        </div>
      {{/if}}
    {{/if}}
  </template>
}
