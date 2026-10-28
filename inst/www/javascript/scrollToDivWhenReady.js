// Scroll to a div once it is visible, and close any open navbar dropdown.
// Used by crukNavLink(). Call as scrollToDivWhenReady(id, timeoutMs).
// `id` is the full DOM id. A bare id also works: if no exact match exists, the
// first visible element whose id ends in "-<id>" is used (module namespaces).
window.scrollToDivWhenReady = (function () {
  let timer = null; // one active poll at a time

  function isVisible(el) {
    return el.getClientRects().length > 0 &&
           getComputedStyle(el).visibility !== "hidden";
  }

  function findTarget(id) {
    const exact = document.getElementById(id);
    if (exact) return exact;

    const suffix = "-" + id;
    return Array.from(document.querySelectorAll("[id]"))
      .filter(function (el) { return el.id.endsWith(suffix) && isVisible(el); })[0] || null;
  }

  function closeNavbarDropdowns() {
    const Dropdown = window.bootstrap && window.bootstrap.Dropdown;

    // Find open dropdowns from both sides. Selecting a tab inside a menu can
    // leave `.show` on the <ul class="dropdown-menu"> while its toggle still
    // reports aria-expanded="false", so looking at toggles alone misses it.
    const toggles = new Set(document.querySelectorAll(
      '.navbar .dropdown-toggle.show, .navbar .dropdown-toggle[aria-expanded="true"]'
    ));
    const orphanMenus = [];

    document.querySelectorAll(".navbar .dropdown-menu.show").forEach(function (menu) {
      const toggle = menu.parentElement &&
        menu.parentElement.querySelector(":scope > .dropdown-toggle");
      if (toggle) {
        toggles.add(toggle);
      } else {
        orphanMenus.push(menu);
      }
    });

    toggles.forEach(function (toggle) {
      // Let Bootstrap tear down its popper first, then clean up by hand in case
      // the instance thought the menu was already closed (hide() is a no-op then).
      const instance = Dropdown && Dropdown.getInstance(toggle);
      if (instance) instance.hide();

      toggle.classList.remove("show");
      toggle.setAttribute("aria-expanded", "false");
      const menu = toggle.nextElementSibling;
      if (menu && menu.classList.contains("dropdown-menu")) {
        menu.classList.remove("show");
      }
    });

    orphanMenus.forEach(function (menu) { menu.classList.remove("show"); });

    if (window.scrollToDivWhenReady && window.scrollToDivWhenReady.debug) {
      console.log("scrollToDivWhenReady: closed", toggles.size, "toggle(s) and",
                  orphanMenus.length, "orphan menu(s)");
    }
  }

  // Bootstrap's Tab plugin can mark the parent dropdown as open *after* the
  // pane becomes visible (it does so when the tab transition completes), so a
  // single close at "pane visible" time can be undone. Close again when the tab
  // reports it has been shown, with a timed fallback in case that event has
  // already fired or never fires.
  function closeAgainAfterTabShown() {
    function handler() { closeNavbarDropdowns(); }
    document.addEventListener("shown.bs.tab", handler, { once: true });
    setTimeout(function () {
      document.removeEventListener("shown.bs.tab", handler);
      closeNavbarDropdowns();
    }, 1000);
  }

  const scrollToDivWhenReady = function (id, timeoutMs) {
    timeoutMs = timeoutMs || 5000;
    if (timer) clearInterval(timer); // cancel any earlier poll
    const start = Date.now();

    timer = setInterval(function () {
      const el = findTarget(id);

      if (el && isVisible(el)) {
        clearInterval(timer);
        timer = null;
        closeNavbarDropdowns();
        closeAgainAfterTabShown();
        // Two frames lets layout settle after the tab transition / dropdown collapse
        requestAnimationFrame(function () {
          requestAnimationFrame(function () {
            el.scrollIntoView({ behavior: "smooth", block: "start" });
          });
        });
      } else if (Date.now() - start > timeoutMs) {
        clearInterval(timer);
        timer = null;
        closeNavbarDropdowns(); // don't leave the menu open on failure
        console.warn("scrollToDivWhenReady: no visible element found for '" + id + "'");
      }
    }, 100);
  };

  // Version marker: lets you confirm in the console which copy of this file
  // the browser loaded (a cached older copy has no .version).
  scrollToDivWhenReady.version = "3";
  // Set scrollToDivWhenReady.debug = true in the console to log each close.
  scrollToDivWhenReady.debug = false;
  // Exposed so the close step can be run by hand while debugging.
  scrollToDivWhenReady.closeDropdowns = closeNavbarDropdowns;

  return scrollToDivWhenReady;
})();
