import Component from "@glimmer/component";
import { service } from "@ember/service";
import CustomCategoryBoxes from "./custom-category-boxes";

export default class LibertyCategoryBoxes extends Component {
  @service site;
  @service router;

  // ── Add every slug that belongs to this box set ───────────────────────────
  // From your console output the format is "parent-slug/child-slug/id"
  // We extract just the slug parts and check against this list
  get allowedSlugs() {
    return [
      "linux",   
      "linux/hardware",
      "linux/software",
      "linux/system-einrichten-und-verwalten",
      "linux/tipps-und-tricks",
      "linux/libertyos-ubuntu",
      "android",
      "android/handys-und-tablets",
      "android/libertyphone-grapheneos"
      "andorid/tipps-und-tricks",
      "allgemein",
    ];
  }

  get currentSlug() {
    let r = this.router.currentRoute;
    while (r) {
      if (r.params?.category_slug_path_with_id) {
        const parts = r.params.category_slug_path_with_id.split("/");
        // Strip the trailing numeric id, keep only slug parts
        const slugParts = parts.filter((p) => isNaN(p));
        // Return the deepest slug (most specific)
        return slugParts.at(-1);
      }
      r = r.parent;
    }
    return null;
  }

  get shouldDisplay() {
    return this.allowedSlugs.includes(this.currentSlug);
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
