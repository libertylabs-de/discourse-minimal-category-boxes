import { apiInitializer } from "discourse/lib/api";
import LibertyCategoriesDisplay from "../components/liberty-categories-display";

export default apiInitializer((api) => {
  api.onPageChange(() => {
    const route = api.container.lookup("service:router");

    if (
      route.currentRouteName === "discovery.index" ||
      route.currentRouteName === "discovery.categories"
    ) {
      api.renderInOutlet(
        "below-site-header",
        LibertyCategoriesDisplay
      );
    }
  });
});
