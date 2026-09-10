import Component from "@glimmer/component";
import { service } from "@ember/service";
import CustomCategoryBoxes from "./custom-category-boxes";

export default class LibertyCategoryBoxes extends Component {
  @service site;
  @service router;

  get shouldDisplay() {
    const name = this.router.currentRoute?.name ?? "";
    return (
      name.includes("discovery.categories") ||
      name.includes("discovery.latest")     ||
      name === "discovery.index"
    );
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
