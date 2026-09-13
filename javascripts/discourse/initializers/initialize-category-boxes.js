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

  let observer = null;

  const applyWidth = ([entry]) => {
    if (!entry) {
      return;
    }

    document.documentElement.style.setProperty(
      "--main-outer-width",
      `${Math.round(entry.contentRect.width)}px`
    );
  };

  const attachObserver = () => {
    const mainOutletWrapper = document.getElementById(
      "main-outlet-wrapper"
    );

    if (!mainOutletWrapper) {
      return;
    }

    observer?.disconnect();
    observer = new ResizeObserver(applyWidth);
    observer.observe(mainOutletWrapper);
  };

  attachObserver();

  api.onPageChange(() => {
    requestAnimationFrame(attachObserver);
  });
});
