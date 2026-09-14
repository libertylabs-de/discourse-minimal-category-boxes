import { apiInitializer } from "discourse/lib/api";
import { registerDestructor } from "@ember/destroyable";

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
    if (attached) {
      return;
    }

    const mainOutlet = document.getElementById(
      "main-outlet-wrapper"
    );

    if (!mainOutlet) {
      return;
    }

    observer = new ResizeObserver(applyWidth);
    observer.observe(mainOutlet);
    attached = true;
  };

  const refreshObserver = () => {
    observer?.disconnect();
    observer = null;
    attached = false;

    requestAnimationFrame(() => {
      attachObserver();
    });
  };

  attachObserver();

  api.onPageChange(() => {
    refreshObserver();
  });
});
