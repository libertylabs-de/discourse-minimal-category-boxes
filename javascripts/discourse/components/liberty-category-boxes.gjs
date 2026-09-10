import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoriesBoxes from "discourse/components/categories-boxes";

export default class LibertyCategoryBoxes extends Component {
  @service site;

  get categories() {
    return this.site.categories;
  }

  <template>
    <div class="custom-category-boxes-container">
      <h1 class="custom-category-header"> 
        <CategoriesBoxes
        @categories={{this.categories}}
      />
    </div>
  </template>
}
