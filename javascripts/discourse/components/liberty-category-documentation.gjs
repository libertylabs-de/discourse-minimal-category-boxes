import Component from "@glimmer/component";
import { service } from "@ember/service";
import CustomCategoryBoxes from "./custom-category-boxes";

export default class LibertyCategoryDocumentationRouter extends Component {
  @service site;
  @service router;

  get allowedSlugs() {
    return [
      "dokumentation",
      "dokumentation/libertyos",
      "dokumentation/libertyos-classic",
      "dokumentation/libertyos-atomic",
      "dokumentation/grapheneos",
    ];
  }

  get currentSlugPath() {
  let route = this.router.currentRoute;

  while (route) {
    const raw = route.params?.category_slug_path_with_id;

    if (typeof raw === "string" && raw.length > 0) {
      return raw
        .split("/")
        .filter((part) => !/^\d+$/.test(part))
        .join("/");
    }

    route = route.parent;
  }

  return null;
  }

  get shouldDisplay() {
    return this.allowedSlugs.includes(this.currentSlugPath);
  }

  get outletArgs() {
    return { categories: this.site.categories };
  }

  <template>
    {{#if this.shouldDisplay}}
      <CustomCategoryBoxes @outletArgs={{this.outletArgs}} />
    {{/if}}
  </template>
}
