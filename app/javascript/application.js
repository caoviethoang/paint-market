// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Custom JavaScript to ensure functionality
document.addEventListener('DOMContentLoaded', function() {
  console.log('Application JavaScript loaded');
  
  // Ensure all interactive elements are working
  setupInteractiveElements();
});

function setupInteractiveElements() {
  // Setup locale selector
  const localeSelect = document.querySelector('select[name="switch_to_locale"]');
  if (localeSelect) {
    console.log('Setting up locale selector');
    localeSelect.addEventListener('change', function() {
      const selectedLocale = this.value;
      console.log('Locale changed to:', selectedLocale);
      
      // Submit the form
      const form = this.closest('form');
      if (form) {
        form.submit();
      } else {
        // Fallback
        window.location.href = `/locale/set?switch_to_locale=${selectedLocale}`;
      }
    });
  }

  // Setup cart link
  const cartLink = document.getElementById('link-to-cart');
  if (cartLink) {
    console.log('Setting up cart link');
    cartLink.addEventListener('click', function(e) {
      e.preventDefault();
      console.log('Cart clicked');
      window.location.href = '/cart';
    });
  }

  // Setup user account link
  const userLinks = document.querySelectorAll('a[href*="login"], a[href*="account"]');
  userLinks.forEach(function(link) {
    console.log('Setting up user link:', link.href);
    link.addEventListener('click', function(e) {
      console.log('User link clicked:', this.href);
    });
  });
}
