import { apiInitializer } from "discourse/lib/api";
import LibertyCategoryBoxes from "../components/liberty-category-boxes";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "below-site-header",
    LibertyCategoryBoxes
  );

  if (typeof ResizeObserver === "undefined") {
    return;
  }

  let observer;

  const attachObserver = () => {
    const mainOutlet = document.getElementById("main-outlet-wrapper");

    if (!mainOutlet) {
      return;
    }

    observer?.disconnect();

    observer = new ResizeObserver(([entry]) => {
      document.documentElement.style.setProperty(
        "--main-outer-width",
        `${Math.round(entry.contentRect.width)}px`
      );
    });

    observer.observe(mainOutlet);
  };

  attachObserver();
  api.onPageChange(attachObserver);
});
