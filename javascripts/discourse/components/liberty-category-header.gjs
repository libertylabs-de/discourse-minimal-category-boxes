import Component from "@glimmer/component";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";

import CategoryLogo from "discourse/components/category-logo";
import CategoryTitleBefore from "discourse/components/category-title-before";

export default class LibertyCategoryHeader extends Component {
  @service router;

  category = null;
  categoryLoaded = false;
  categoryLoading = false;

  constructor(owner, args) {
    super(owner, args);

    this.loadCurrentCategory();
  }

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

  async loadCurrentCategory() {
    const id = this.categoryId;

    if (
      !id ||
      this.categoryLoaded ||
      this.categoryLoading
    ) {
      return;
    }

    this.categoryLoading = true;

    try {
      const response = await ajax(
        `/c/${id}.json`
      );

      this.category =
        response.category ||
        response;

      this.categoryLoaded = true;
    } catch (error) {
      console.error(
        "[LibertyCategoryHeader] Failed to load category:",
        error
      );
    } finally {
      this.categoryLoading = false;
    }
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
