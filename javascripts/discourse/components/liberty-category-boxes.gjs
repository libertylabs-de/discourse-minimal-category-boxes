import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoriesBoxesWithTopics from "discourse/components/categories-boxes-with-topics";

export default class LibertyCategoryBoxes extends Component {
  @service categoryStore;

  get categories() {
    return this.categoryStore?.get("categories") || [];
  }

  <template>
    <CategoriesBoxesWithTopics
      @categories={{this.categories}}
    />
  </template>
}
