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

  // Setup hamburger menu
  const hamburgerButtons = document.querySelectorAll('[data-action*="drawer#toggle"]');
  hamburgerButtons.forEach(function(button) {
    console.log('Setting up hamburger menu');
    button.addEventListener('click', function(e) {
      e.preventDefault();
      console.log('Hamburger menu clicked');
      const drawer = document.querySelector('[data-drawer-target="drawer"]');
      const overlay = document.getElementById('overlay');
      
      if (drawer && overlay) {
        drawer.classList.toggle('-translate-x-full');
        overlay.classList.toggle('hidden');
        console.log('Drawer toggled');
      }
    });
  });

  // Setup mobile carousel
  const carouselContainer = document.getElementById('mobile-carousel');
  if (carouselContainer) {
    console.log('Setting up mobile carousel');
    
    let startX = 0;
    let currentX = 0;
    let isDragging = false;
    let currentSlide = 0;
    const totalSlides = 6;
    
    function updateCarousel() {
      const translateX = -currentSlide * 45;
      carouselContainer.style.transform = `translateX(${translateX}%)`;
      updateIndicators();
    }
    
    function updateIndicators() {
      const indicators = document.querySelectorAll('.carousel-indicator');
      indicators.forEach((indicator, index) => {
        if (index === currentSlide) {
          indicator.classList.remove('bg-gray-300');
          indicator.classList.add('bg-gray-700');
        } else {
          indicator.classList.remove('bg-gray-700');
          indicator.classList.add('bg-gray-300');
        }
      });
    }
    
    carouselContainer.addEventListener('touchstart', function(e) {
      startX = e.touches[0].clientX;
      isDragging = true;
      carouselContainer.style.transition = 'none';
    });
    
    carouselContainer.addEventListener('touchmove', function(e) {
      if (!isDragging) return;
      currentX = e.touches[0].clientX;
      const diffX = currentX - startX;
      const translateX = -currentSlide * 45 + (diffX / window.innerWidth) * 45;
      carouselContainer.style.transform = `translateX(${translateX}%)`;
    });
    
    carouselContainer.addEventListener('touchend', function(e) {
      if (!isDragging) return;
      isDragging = false;
      const diffX = currentX - startX;
      const threshold = window.innerWidth * 0.2;
      
      carouselContainer.style.transition = 'transform 0.3s ease-in-out';
      
      if (Math.abs(diffX) > threshold) {
        if (diffX > 0) {
          // Swipe right - go to previous slide
          currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
        } else {
          // Swipe left - go to next slide
          currentSlide = (currentSlide + 1) % totalSlides;
        }
      }
      updateCarousel();
    });
    
    // Initialize
    updateCarousel();
  }
}
