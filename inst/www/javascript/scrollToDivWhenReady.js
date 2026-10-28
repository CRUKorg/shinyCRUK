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
    document
      .querySelectorAll('.navbar .dropdown-toggle.show, .navbar .dropdown-toggle[aria-expanded="true"]')
      .forEach(function (toggle) {
        const Dropdown = window.bootstrap && window.bootstrap.Dropdown;
        const instance = Dropdown && Dropdown.getInstance(toggle);
        if (instance) {
          instance.hide();
        } else {
          // Fallback if the bootstrap global isn't exposed
          toggle.classList.remove("show");
          toggle.setAttribute("aria-expanded", "false");
          const menu = toggle.nextElementSibling;
          if (menu && menu.classList.contains("dropdown-menu")) {
            menu.classList.remove("show");
          }
        }
      });
  }

  return function (id, timeoutMs) {
    timeoutMs = timeoutMs || 5000;
    if (timer) clearInterval(timer); // cancel any earlier poll
    const start = Date.now();

    timer = setInterval(function () {
      const el = findTarget(id);

      if (el && isVisible(el)) {
        clearInterval(timer);
        timer = null;
        closeNavbarDropdowns();
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
})();
