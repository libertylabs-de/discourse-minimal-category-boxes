import Component from "@glimmer/component";
import { service } from "@ember/service";
import CustomCategoryBoxes from "./custom-category-boxes";

export default class LibertyCategoryLinuxRouter extends Component {
  @service site;
  @service router;

  get allowedSlugs() {
    return [
      "linux/hardware",
      "linux/software",
      "linux/libertyos-ubuntu",
      "linux/andere-distros",
    ];
  }

  get currentSlugPath() {
    let r = this.router.currentRoute;
    while (r) {
      if (r.params?.category_slug_path_with_id) {
        const parts = r.params.category_slug_path_with_id.split("/");
        return parts.filter((p) => isNaN(p)).join("/");
      }
      r = r.parent;
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
