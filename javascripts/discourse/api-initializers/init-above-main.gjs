import { apiInitializer } from "discourse/lib/api";
import CategoriesBoxes from "discourse/components/categories-boxes";

export default apiInitializer((api) => {
  api.renderInOutlet("below-site-header", CategoriesBoxes);
});
