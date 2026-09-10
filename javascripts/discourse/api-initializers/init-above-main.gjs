import { apiInitializer } from "discourse/lib/api";
import LibertyCategoryBoxes from "../components/liberty-category-boxes";

export default apiInitializer((api) => {
  api.renderInOutlet("below-site-header", LibertyCategoryBoxes);
});
