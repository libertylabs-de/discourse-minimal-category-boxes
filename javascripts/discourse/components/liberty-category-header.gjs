import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoryLogo from "discourse/components/category-logo";
import CategoryTitleBefore from "discourse/components/category-title-before";

export default class LibertyCategoryHeader extends Component {
  @service router;
  @service site;

  get currentSlugPath() {
    let route = this.router.currentRoute;

    while (route) {
      const rawSlugPath =
        route.params?.category_slug_path_with_id;

      if (
        typeof rawSlugPath === "string" &&
        rawSlugPath.length > 0
      ) {
        return rawSlugPath
          .split("/")
          .filter((part) => !/^\d+$/.test(part))
          .join("/");
      }

      route = route.parent;
    }

    return null;
  }

  get category() {
    const slugPath = this.currentSlugPath;

    if (!slugPath) {
      return null;
    }

    return (
      (this.site.categories ?? []).find((category) => {
        return (
          category.slug === slugPath ||
          category.fullSlug === slugPath ||
          category.slugPath === slugPath
        );
      }) ?? null
    );
  }

  get shouldDisplay() {
    const routeName = this.router.currentRouteName ?? "";

    return Boolean(
      routeName.startsWith("discovery.category") &&
        this.category
    );
  }

  <template>
    {{#if this.shouldDisplay}}
      <div class="liberty-category-header">
        <div class="liberty-category-header-inner">
          {{#if this.category.uploaded_logo.url}}
            <CategoryLogo @category={{this.category}} />
          {{/if}}

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
      </div>
    {{/if}}
  </template>
}
