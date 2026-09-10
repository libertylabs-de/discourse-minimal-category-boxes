import { apiInitializer } from "discourse/lib/api";
//import LibertyCategoryBoxes from "../components/liberty-category-boxes";
import LibertyCategoryAndroid      from "../components/liberty-category-linux";
import LibertyCategoryAndroid   from "../components/liberty-category-android";

export default apiInitializer((api) => {

  // ── 1. Inject category boxes above main content ──────────────────────────
  api.renderInOutlet("below-site-header", LibertyCategoryLinux);
  api.renderInOutlet("below-site-header", LibertyCategoryAndroid);
  
  // ── 2. Mirror #main-outlet-wrapper's live width onto --main-outer-width ──
  if (typeof ResizeObserver === "undefined") return;

  let observer = null;
  let attached = false;

  const applyWidth = (entries) => {
    for (const entry of entries) {
      document.documentElement.style.setProperty(
        "--main-outer-width",
        `${Math.round(entry.contentRect.width)}px`
      );
    }
  };

  const attachObserver = () => {
    if (attached) return;
    const mainOutlet = document.getElementById("main-outlet-wrapper");
    if (!mainOutlet) return;
    observer = new ResizeObserver(applyWidth);
    observer.observe(mainOutlet);
    attached = true;
  };

  attachObserver();

  api.onPageChange(() => {
    if (!attached) {
      attachObserver();
    } else {
      observer?.disconnect();
      attached = false;
      attachObserver();
    }
  });
});
