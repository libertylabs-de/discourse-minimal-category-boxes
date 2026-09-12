import Component from "@glimmer/component";
import { service } from "@ember/service";
import CustomCategoryBoxes from "./custom-category-boxes";

export default class LibertyCategoryBoxes extends Component {
  @service router;
  @service site;

  get currentSlugPath() {
    let route = this.router.currentRoute;

    while (route) {
      const slugPath = route.params?.category_slug_path_with_id;

      if (slugPath) {
        return slugPath
          .split("/")
          .filter((part) => !/^\d+$/.test(part))
          .join("/");
      }

      route = route.parent;
    }

    return null;
  }

  get shouldDisplay() {
    return Boolean(this.currentSlugPath);
  }

  get outletArgs() {
    return {
      categories: this.site.categories,
    };
  }

  <template>
    {{#if this.shouldDisplay}}
      <CustomCategoryBoxes @outletArgs={{this.outletArgs}} />
    {{/if}}
  </template>
}
