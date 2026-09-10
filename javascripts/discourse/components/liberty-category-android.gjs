import Component from "@glimmer/component";
import { service } from "@ember/service";
import LibertyCategoryAndroid from "./liberty-category-android";

export default class LibertyCategoryAndroid extends Component {
  @service site;
  @service router;

  // ── Which slugs should show THIS box set ──────────────────────────────────
  // Add every slug that should trigger display: the parent + all subcategories
  get allowedSlugs() {
    return [
      "android",      // ← replace with your actual slug
      "android/libertyphone-grapheneos",          
      "android/tipps-und-tricks",
    ];
  }

  // Option A: match against full path (no id)
  get currentSlugPath() {
    let r = this.router.currentRoute;
    while (r) {
      if (r.params?.category_slug_path_with_id) {
        const parts = r.params.category_slug_path_with_id.split("/");
        // Remove trailing numeric id
        return parts.filter((p) => isNaN(p)).join("/");
      }
      r = r.parent;
    }
    return null;
  }

  get allowedSlugs() {
    return [
      "android",
      "android/libertyphone-grapheneos",
      "android/tipps-und-tricks",
    ];
  }
  
  get shouldDisplay() {
    return this.allowedSlugs.includes(this.currentSlugPath);
  }

  get outletArgs() {
    return { categories: this.site.categories };
  }

  <template>
    {{#if this.shouldDisplay}}
      <LibertyCategoryAndroid @outletArgs={{this.outletArgs}} />
    {{/if}}
  </template>
