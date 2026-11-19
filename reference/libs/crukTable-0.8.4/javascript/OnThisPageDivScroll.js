
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.scroll-link').forEach(function(link) {
      link.addEventListener('click', function(e) {
        e.preventDefault();
        const targetId = this.getAttribute('href').replace('#', '');
        const target = document.getElementById(targetId);
        if (target) {
          target.scrollIntoView({ behavior: 'smooth' });
          const currentUrl = window.location.pathname + window.location.search;
          history.pushState(null, null, currentUrl + '#' + targetId);


        }
      });
    });
  });
