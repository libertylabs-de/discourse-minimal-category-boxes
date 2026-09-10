import { apiInitializer } from "discourse/lib/api";
import LibertyCategoriesDisplay from "../components/liberty-categories-display";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "below-site-header",
    LibertyCategoriesDisplay
  );
});
