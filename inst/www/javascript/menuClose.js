// Wait until the entire DOM content has loaded before executing
document.addEventListener('DOMContentLoaded', function() {

  // Select all nav links inside .navbar-nav, excluding dropdown toggles
  const navLinks = document.querySelectorAll('.navbar-nav .nav-link:not(.dropdown-toggle)');

  // Select all elements with the class .dropdown-item (typically inside dropdown menus)
  const dropdownItems = document.querySelectorAll('.dropdown-item');

  // Function to collapse the navbar with animation
  function animateCollapse(navbarCollapse) {
    // Set initial height to current content height to enable transition
    navbarCollapse.style.height = navbarCollapse.scrollHeight + 'px';

    // Trigger a reflow so the browser acknowledges the height before collapsing
    navbarCollapse.offsetHeight;

    // Switch Bootstrap collapse classes to prepare for manual transition
    navbarCollapse.classList.remove('show');
    navbarCollapse.classList.remove('collapse');
    navbarCollapse.classList.add('collapsing');

    // Set transition properties and start collapsing to 0 height
    navbarCollapse.style.transition = 'height 0.35s ease';
    navbarCollapse.style.height = '0px';

    // After the transition completes
    navbarCollapse.addEventListener('transitionend', function handler() {
      // Restore final collapsed state classes and remove inline styles
      navbarCollapse.classList.remove('collapsing');
      navbarCollapse.classList.add('collapse');
      navbarCollapse.style.height = '';
      navbarCollapse.style.transition = '';

      // Remove this event listener after it fires
      navbarCollapse.removeEventListener('transitionend', handler);
    });
  }

  // Function to collapse the menu if screen width is below Bootstrap's lg breakpoint
  function collapseMenu() {
    if (window.innerWidth < 992) {
      const navbarCollapse = document.querySelector('.navbar-collapse');
      const navbarToggle = document.querySelector('.navbar-toggle');

      // Collapse the navbar if it's currently expanded
      if (navbarCollapse && navbarCollapse.classList.contains('show')) {
        animateCollapse(navbarCollapse);
      }

      // Reset the hamburger icon state and accessibility attributes
      if (navbarToggle) {
        navbarToggle.classList.add('collapsed');
        navbarToggle.setAttribute('aria-expanded', 'false');
      }
    }
  }

  // Attach the collapseMenu function to each nav link click (non-dropdown)
  navLinks.forEach(function(link) {
    link.addEventListener('click', collapseMenu);
  });

  // Attach the collapseMenu function to each dropdown item click
  dropdownItems.forEach(function(item) {
    item.addEventListener('click', collapseMenu);
  });
});