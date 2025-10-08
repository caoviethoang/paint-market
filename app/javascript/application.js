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

  // Setup collapse functionality - strict fallback aligned to FilterComponent
  function setupCollapse() {
    console.log('Setting up collapse functionality...');

    const containers = document.querySelectorAll('[data-controller="collapse"], [data-controller*="collapse"]');
    containers.forEach((container) => {
      const trigger = container.querySelector('[data-action*="collapse#toggle"]');
      const content = container.querySelector('[data-collapse-target="content"], .collapse-content');
      const icon = container.querySelector('[data-collapse-target="icon"], .collapse-icon, svg');

      if (!trigger || !content) return;

      const onClick = (e) => {
        e.preventDefault();
        e.stopPropagation();
        const isVisible = !content.classList.contains('hidden');
        if (isVisible) {
          content.classList.add('hidden');
          if (icon) icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>';
        } else {
          content.classList.remove('hidden');
          if (icon) icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 12h12"></path>';
        }
      };

      trigger.removeEventListener('click', onClick);
      trigger.addEventListener('click', onClick);
    });

    // Delegation fallback
    document.addEventListener('click', function(e) {
      const trigger = e.target.closest('[data-action*="collapse#toggle"], .collapse-trigger');
      if (!trigger) return;
      const container = trigger.closest('[data-controller*="collapse"], .filter-item') || trigger.parentElement;
      const content = container && container.querySelector('[data-collapse-target="content"], .collapse-content');
      const icon = container && (container.querySelector('[data-collapse-target="icon"], .collapse-icon, svg'));
      if (!content) return;
      e.preventDefault();
      e.stopPropagation();
      const isVisible = !content.classList.contains('hidden');
      if (isVisible) {
        content.classList.add('hidden');
        if (icon) icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>';
      } else {
        content.classList.remove('hidden');
        if (icon) icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 12h12"></path>';
      }
    });
  }
  
  // Setup collapse immediately
  setupCollapse();
  
  // Also setup collapse after a delay to catch dynamically loaded content
  setTimeout(setupCollapse, 1000);
  
  // Event delegation approach - catch all clicks and check if they should trigger collapse
  document.addEventListener('click', function(e) {
    const target = e.target;
    
    // Check if clicked element or its parent should trigger collapse
    const collapseTrigger = target.closest('[data-action*="collapse#toggle"], [data-collapse-target="trigger"], .collapse-trigger, [data-toggle="collapse"], .filter-toggle');
    
    if (collapseTrigger) {
      e.preventDefault();
      e.stopPropagation();
      console.log('Collapse triggered via event delegation:', collapseTrigger);
      
      // Find the closest container
      const container = collapseTrigger.closest('[data-controller*="collapse"]') || 
                       collapseTrigger.closest('.filter-item') || 
                       collapseTrigger.parentElement;
      
      // Find content to toggle
      let content = container ? container.querySelector('[data-collapse-target="content"], .collapse-content, .filter-content') : null;
      
      if (content) {
        const isVisible = !content.classList.contains('hidden');
        console.log('Toggling content visibility:', isVisible ? 'hide' : 'show');
        
        if (isVisible) {
          content.classList.add('hidden');
        } else {
          content.classList.remove('hidden');
        }
        
        // Update icon if found
        const icon = collapseTrigger.querySelector('svg') || container?.querySelector('svg');
        if (icon) {
          if (isVisible) {
            icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>';
          } else {
            icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 12h12"></path>';
          }
        }
      }
    }
  });

  // Setup mobile carousel
  const carouselContainer = document.getElementById('mobile-carousel');
  if (carouselContainer) {
    console.log('Setting up mobile carousel');
    
    let startX = 0;
    let currentX = 0;
    let isDragging = false;
    let currentSlide = 0;
    const totalSlides = 6; // 7 images but showing 2 at a time = 6 slides (0-5)
    
    function updateCarousel() {
      const translateX = -currentSlide * 45;
      console.log('Fallback carousel - slide:', currentSlide, 'translateX:', translateX);
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
    
    function nextSlide() {
      if (currentSlide < totalSlides - 1) {
        currentSlide++;
      } else {
        currentSlide = 0; // Loop back to first slide
      }
      console.log('Fallback next slide:', currentSlide);
      updateCarousel();
    }
    
    function prevSlide() {
      if (currentSlide > 0) {
        currentSlide--;
      } else {
        currentSlide = totalSlides - 1; // Loop to last slide
      }
      console.log('Fallback previous slide:', currentSlide);
      updateCarousel();
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
          prevSlide();
        } else {
          // Swipe left - go to next slide
          nextSlide();
        }
      } else {
        // Snap back to current slide
        updateCarousel();
      }
    });
    
    // Initialize
    updateCarousel();
  }

  // Setup event detail carousel (swipe-based like 7-images)
  const eventCarouselContainer = document.querySelector('[data-controller*="carousel"]');
  if (eventCarouselContainer) {
    console.log('Setting up event detail carousel with swipe');
    
    let eventCurrentSlide = 0;
    const eventSlides = eventCarouselContainer.querySelectorAll('[data-carousel-target="slide"]');
    const eventSlidesWrapper = eventCarouselContainer.querySelector('[data-carousel-target="slides"]');
    
    if (eventSlides.length > 0 && eventSlidesWrapper) {
      console.log('Event carousel found with', eventSlides.length, 'slides');
      
      // Calculate how many slides to show at once based on screen size
      function getSlidesToShow() {
        if (window.innerWidth < 640) return 1; // sm: 1 slide
        if (window.innerWidth < 1024) return 2; // lg: 2 slides  
        return 3; // xl: 3 slides
      }
      
      function updateEventCarousel() {
        if (eventSlides.length === 0) return;
        
        const slidesToShow = getSlidesToShow();
        const maxSlide = Math.max(0, eventSlides.length - slidesToShow);
        
        // Clamp current slide to valid range
        if (eventCurrentSlide > maxSlide) {
          eventCurrentSlide = maxSlide;
        }
        
        const slideWidth = eventSlides[0].offsetWidth;
        const gap = window.innerWidth < 640 ? 8 : 16; // gap-2 (8px) on mobile, gap-4 (16px) on desktop
        const translateX = -eventCurrentSlide * (slideWidth + gap);
        
        console.log('Event carousel - slide:', eventCurrentSlide, 'translateX:', translateX, 'slidesToShow:', slidesToShow);
        eventSlidesWrapper.style.transform = `translateX(${translateX}px)`;
        eventSlidesWrapper.style.transition = 'transform 0.3s ease-in-out';
      }
      
      function nextEventSlide() {
        const slidesToShow = getSlidesToShow();
        const maxSlide = Math.max(0, eventSlides.length - slidesToShow);
        
        if (eventCurrentSlide < maxSlide) {
          eventCurrentSlide++;
        } else {
          eventCurrentSlide = 0; // Loop back to first slide
        }
        console.log('Event carousel next slide:', eventCurrentSlide);
        updateEventCarousel();
      }
      
      function prevEventSlide() {
        const slidesToShow = getSlidesToShow();
        const maxSlide = Math.max(0, eventSlides.length - slidesToShow);
        
        if (eventCurrentSlide > 0) {
          eventCurrentSlide--;
        } else {
          eventCurrentSlide = maxSlide; // Loop to last valid slide
        }
        console.log('Event carousel prev slide:', eventCurrentSlide);
        updateEventCarousel();
      }
      
      // Setup prev/next buttons (desktop only)
      const prevButton = eventCarouselContainer.querySelector('[data-action*="carousel#prev"]');
      const nextButton = eventCarouselContainer.querySelector('[data-action*="carousel#next"]');
      
      if (prevButton) {
        prevButton.addEventListener('click', function(e) {
          e.preventDefault();
          console.log('Event carousel prev button clicked');
          prevEventSlide();
        });
      }
      
      if (nextButton) {
        nextButton.addEventListener('click', function(e) {
          e.preventDefault();
          console.log('Event carousel next button clicked');
          nextEventSlide();
        });
      }
      
      // Enhanced touch/swipe support (primary interaction on mobile)
      let eventStartX = 0;
      let eventCurrentX = 0;
      let eventIsDragging = false;
      let eventStartTime = 0;
      
      eventSlidesWrapper.addEventListener('touchstart', function(e) {
        eventStartX = e.touches[0].clientX;
        eventStartTime = Date.now();
        eventIsDragging = true;
        eventSlidesWrapper.style.transition = 'none';
        console.log('Event carousel touch start');
      });
      
      eventSlidesWrapper.addEventListener('touchmove', function(e) {
        if (!eventIsDragging) return;
        eventCurrentX = e.touches[0].clientX;
        const diffX = eventCurrentX - eventStartX;
        const slideWidth = eventSlides[0].offsetWidth;
        const gap = window.innerWidth < 640 ? 8 : 16;
        const translateX = -eventCurrentSlide * (slideWidth + gap) + diffX;
        eventSlidesWrapper.style.transform = `translateX(${translateX}px)`;
      });
      
      eventSlidesWrapper.addEventListener('touchend', function(e) {
        if (!eventIsDragging) return;
        eventIsDragging = false;
        
        const diffX = eventCurrentX - eventStartX;
        const diffTime = Date.now() - eventStartTime;
        const threshold = window.innerWidth * 0.15; // 15% of screen width
        const velocity = Math.abs(diffX) / diffTime; // pixels per ms
        
        eventSlidesWrapper.style.transition = 'transform 0.3s ease-in-out';
        
        // Check for swipe gesture (distance or velocity)
        if (Math.abs(diffX) > threshold || velocity > 0.5) {
          if (diffX > 0) {
            // Swipe right - go to previous slide
            prevEventSlide();
          } else {
            // Swipe left - go to next slide
            nextEventSlide();
          }
        } else {
          // Snap back to current slide
          updateEventCarousel();
        }
        
        console.log('Event carousel touch end - diffX:', diffX, 'velocity:', velocity);
      });
      
      // Mouse support for desktop (optional)
      let mouseStartX = 0;
      let mouseIsDragging = false;
      
      eventSlidesWrapper.addEventListener('mousedown', function(e) {
        mouseStartX = e.clientX;
        mouseIsDragging = true;
        eventSlidesWrapper.style.transition = 'none';
        e.preventDefault();
      });
      
      eventSlidesWrapper.addEventListener('mousemove', function(e) {
        if (!mouseIsDragging) return;
        const diffX = e.clientX - mouseStartX;
        const slideWidth = eventSlides[0].offsetWidth;
        const gap = 16;
        const translateX = -eventCurrentSlide * (slideWidth + gap) + diffX;
        eventSlidesWrapper.style.transform = `translateX(${translateX}px)`;
      });
      
      eventSlidesWrapper.addEventListener('mouseup', function(e) {
        if (!mouseIsDragging) return;
        mouseIsDragging = false;
        
        const diffX = e.clientX - mouseStartX;
        const threshold = 100; // 100px threshold for mouse
        
        eventSlidesWrapper.style.transition = 'transform 0.3s ease-in-out';
        
        if (Math.abs(diffX) > threshold) {
          if (diffX > 0) {
            prevEventSlide();
          } else {
            nextEventSlide();
          }
        } else {
          updateEventCarousel();
        }
      });
      
      // Handle window resize
      window.addEventListener('resize', function() {
        updateEventCarousel();
      });
      
      // Initialize
      updateEventCarousel();
    }
  }
}
