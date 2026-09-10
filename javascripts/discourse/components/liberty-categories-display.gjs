import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoriesDisplay from "discourse/components/discovery/categories-display";

export default class LibertyCategoriesDisplay extends Component {
  @service site;

  get categories() {
    return this.site.categories;
  }

  <template>
    <CategoriesDisplay
      @categories={{this.categories}}
    />
  </template>
}
