import Component from "@glimmer/component";
import { service } from "@ember/service";
import CustomCategoryBoxes from "./custom-category-boxes";

export default class LibertyMainCategories extends Component {
  @service router;
  @service site;

  get shouldDisplay() {
    const routeName = this.router.currentRouteName ?? "";

    return (
      routeName === "discovery.index" ||
      routeName === "discovery.categories"
    );
  }

  get outletArgs() {
    return {
      categories: this.site.categories ?? [],
    };
  }

  <template>
    {{#if this.shouldDisplay}}
      <div class="liberty-main-categories">
        <CustomCategoryBoxes
          @outletArgs={{this.outletArgs}}
        />
      </div>
    {{/if}}
  </template>
}
