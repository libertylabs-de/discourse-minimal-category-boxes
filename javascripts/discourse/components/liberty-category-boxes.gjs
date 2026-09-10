import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoriesBoxes from "discourse/components/categories-boxes";

export default class LibertyCategoryBoxes extends Component {
  @service categoryStore;

  get categories() {
    return this.categoryStore?.get("categories") || [];
  }

  <template>
    <CategoriesBoxes
      @categories={{this.categories}}
    />
  </template>
}
