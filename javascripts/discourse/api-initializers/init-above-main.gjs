import { apiInitializer } from "discourse/lib/api";
import LibertyCategoryBoxes from "../components/liberty-category-boxes";

export default apiInitializer((api) => {

  // ── 1. Inject category boxes above main content ──────────────────────────
  api.renderInOutlet("below-site-header", LibertyCategoryBoxes);

  // ── 2. Mirror #main-outer-wrapper's live width onto --main-outer-width ───
  // Allows SCSS to match the main content area width precisely,
  // regardless of sidebar open/collapsed/disabled state.
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
    const mainOuter = document.getElementById("main-outer-wrapper");
    if (!mainOuter) return;

    observer = new ResizeObserver(applyWidth);
    observer.observe(mainOuter);
    attached = true;
  };

  // Try immediately (works if DOM is already rendered)
  attachObserver();

  // Re-try on every page change in case the element wasn't in the DOM yet
  api.onPageChange(() => {
    if (!attached) {
      attachObserver();
    } else {
      // Re-observe after navigation in case #main-outer-wrapper was recreated
      observer?.disconnect();
      attached = false;
      attachObserver();
    }
  });
});
