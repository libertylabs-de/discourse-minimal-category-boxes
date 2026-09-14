import Service from "@ember/service";
import { ajax } from "discourse/lib/ajax";

export default class LibertyCategoryTreeService extends Service {
  categories = [];

  isLoaded = false;

  async load() {
    if (this.isLoaded) {
      return this.categories;
    }

    const response = await ajax(
      "/categories.json?include_subcategories=true"
    );

    this.categories = response.categories ?? [];
    this.isLoaded = true;

    return this.categories;
  }
}
