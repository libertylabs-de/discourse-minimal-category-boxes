import Component from "@glimmer/component";
import { service } from "@ember/service";
import CustomCategoryBoxes from "./custom-category-boxes";

export default class LibertyCategoryBoxes extends Component {
  @service site;

  get outletArgs() {
    // Mimic the outletArgs shape that the discovery outlet normally provides
    return { categories: this.site.categories };
  }

  <template>
    <CustomCategoryBoxes @outletArgs={{this.outletArgs}} />
  </template>
}
