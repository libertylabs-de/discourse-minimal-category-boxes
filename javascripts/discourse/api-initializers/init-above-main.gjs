import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  console.log("[category-boxes] initializer loaded");

  api.renderInOutlet(
    "above-main-container",
    <template>
      <div class="category-boxes-outlet-test">
        Modern Category + Group Boxes outlet test
      </div>
    </template>
  );
});
