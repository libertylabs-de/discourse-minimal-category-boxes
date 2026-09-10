import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "below-site-header",
    <template>
      <div class="category-boxes-outlet-test">
        Modern Category + Group Boxes outlet test
      </div>
    </template>
  );
});
