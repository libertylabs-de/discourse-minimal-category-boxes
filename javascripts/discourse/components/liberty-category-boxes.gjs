import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoriesBoxesWithTopics from "discourse/components/categories-boxes-with-topics";

export default class LibertyCategoryBoxes extends Component {
  @service site;

  get categories() {
    return this.site.categories;
  }

  <template>
    <div class="custom-category-boxes-container">
      <CategoriesBoxesWithTopics
        @categories={{this.categories}}
      />
    </div>
  </template>
}
