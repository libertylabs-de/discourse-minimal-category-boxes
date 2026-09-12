import Component from "@glimmer/component";
import CategoryLogo from "discourse/components/category-logo";
import CategoryTitleBefore from "discourse/components/category-title-before";

export default class LibertyCategoryHeader extends Component {
  get category() {
    return this.args.category;
  }

  get shouldDisplay() {
    return Boolean(this.category);
  }

  <template>
    {{#if this.shouldDisplay}}
      <div class="liberty-category-header-inner">
        <div class="liberty-category-header-title">
          <h1>
            <CategoryTitleBefore
              @category={{this.category}}
            />
            {{this.category.name}}
          </h1>

          {{#if this.category.description_excerpt}}
            <p>
              {{this.category.description_excerpt}}
            </p>
          {{/if}}
        </div>

        {{#if this.category.uploaded_logo.url}}
          <CategoryLogo @category={{this.category}} />
        {{/if}}
      </div>
    {{/if}}
  </template>
}
