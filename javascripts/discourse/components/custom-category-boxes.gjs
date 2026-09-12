import Component from "@glimmer/component";
import { service } from "@ember/service";
import CategoryBoxes from "./category-boxes";
import CategoryHeader from "./category-header";

export default class CustomCategoryBoxes extends Component {
  @service router;
  @service site;

  get classNames() {
    const classes = ["custom-category-boxes-container"];

    if (this.noneSelected) {
      classes.push("none-selected");
    }

    return classes.join(" ");
  }

  get categories() {
    return this.args.outletArgs?.categories ?? this.site.categories ?? [];
  }

  get isOnCategoryPage() {
    return this.router.currentRouteName?.includes("category") ?? false;
  }

  get noneSelected() {
    return this.router.currentRouteName?.includes("None") ?? false;
  }

  /*
   * First recovery version:
   * render all categories and bypass the broken `settings` reference.
   *
   * Reintroduce configured sections only after the boxes work again.
   */
  get shouldRenderHeadings() {
    return false;
  }

  <template>
    <div class={{this.classNames}}>
      {{#if this.categories.length}}
        <CategoryBoxes @categories={{this.categories}} />
      {{/if}}
    </div>
  </template>
}
