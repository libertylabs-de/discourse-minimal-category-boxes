import { apiInitializer } from "discourse/lib/api";
import CategoryBoxes from "../components/custom-category-boxes";

export default apiInitializer((api) => {
  api.renderInOutlet("above-discovery-categories", CategoryBoxes);
});
