import { apiInitializer } from "discourse/lib/api";
import CategoryBoxes from "../components/category-boxes";

export default apiInitializer((api) => {
  api.renderInOutlet("above-discovery-categories", ModernCategoryBoxes);
});
