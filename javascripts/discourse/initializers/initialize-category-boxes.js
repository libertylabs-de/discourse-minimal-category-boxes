import { apiInitializer } from "discourse/lib/api";
import LibertyCategoryBoxes from "../components/liberty-category-boxes";
import LibertyMainCategories from "../components/liberty-main-categories";

export default apiInitializer((api) => {
  api.renderInOutlet(
    "below-site-header",
    LibertyCategoryBoxes
  );

  api.renderInOutlet(
    "above-main-container",
    LibertyMainCategories
  );

  if (typeof ResizeObserver === "undefined") {
    return;
  }

  let observer = null;
  let attached = false;

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
    attached = true;
  };

  const refreshObserver = () => {
    if (!attached) {
      attachObserver();
      return;
    }

    observer?.disconnect();
    observer = null;
    attached = false;
    attachObserver();
  };

  attachObserver();

  api.onPageChange(() => {
    refreshObserver();
  });
});
