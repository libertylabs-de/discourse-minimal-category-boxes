import Component from "@glimmer/component";
import { service } from "@ember/service";
import LibertyCategoryAndroid from "./liberty-category-android";

export default class LibertyCategoryLinux extends Component {
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

  get currentSlug() {
    const route = this.router.currentRoute;
    // Walk up the route tree to find a slug param
    let r = route;
    while (r) {
      if (r.params?.slug) return r.params.slug;
      if (r.params?.category_slug_path_with_id) {
        // Discourse sometimes uses this format: "slug/id"
        return r.params.category_slug_path_with_id.split("/")[0];
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
      <LibertyCategoryAndroid @outletArgs={{this.outletArgs}} />
    {{/if}}
  </template>
