import Component from "@glimmer/component";
import { service } from "@ember/service";
import CustomCategoryBoxes from "./custom-category-boxes";

export default class LibertyCategoryBoxes extends Component {
  @service site;
  @service router;

  get currentSlugPath() {
    let route = this.router.currentRoute;

    while (route) {
      const rawSlugPath = route.params?.category_slug_path_with_id;

      if (typeof rawSlugPath === "string" && rawSlugPath.length > 0) {
        return rawSlugPath
          .split("/")
          .filter((part) => !/^\d+$/.test(part))
          .join("/");
      }

      route = route.parent;
    }

    return null;
  }

  /*
   * Keep the boxes available on the homepage and category pages.
   * This avoids hard-coded Android/Linux slug lists during recovery.
   */
  get shouldDisplay() {
    const routeName = this.router.currentRouteName ?? "";

    return (
      routeName === "discovery.index" ||
      routeName === "discovery.categories" ||
      routeName.startsWith("discovery.category") ||
      routeName === "discovery.subcategories"
    );
  }

  get outletArgs() {
    return {
      categories: this.site.categories ?? [],
    };
  }

  <template>
    {{#if this.shouldDisplay}}
      <CustomCategoryBoxes @outletArgs={{this.outletArgs}} />
    {{/if}}
  </template>
}
