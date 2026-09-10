import { apiInitializer } from "discourse/lib/api";
import CategoryBoxes from "../components/category-boxes";

export default apiInitializer((api) => {
  // Render the same component used by Modern Category + Group Boxes
  // into an outlet outside #main-outlet.
  api.renderInOutlet("below-site-header", CategoryBoxes);
});
