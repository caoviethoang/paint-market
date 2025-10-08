import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["carousel", "indicator"]
  
  connect() {
    this.currentSlide = 0
    this.totalImages = 7
    this.imagesPerView = 2.2 // Show 2 full images + 0.2 peek of next
    // Calculate total slides: with 7 images at 45% width each, we need to scroll to show all
    // Total width = 7 * 45% = 315%, visible = 100%, so we need 5 slides to show all images
    this.totalSlides = 5 // 0, 1, 2, 3, 4 (5 positions to show all 7 images)
    this.startX = 0
    this.currentX = 0
    this.isDragging = false
    
    console.log('Mobile carousel connected!')
    console.log('Total images:', this.totalImages)
    console.log('Total slides:', this.totalSlides)
    console.log('Carousel target:', this.hasCarouselTarget)
    console.log('Indicator targets:', this.hasIndicatorTargets)
    
    this.updateCarousel()
    this.updateIndicators()
    this.addTouchListeners()
  }
  
  disconnect() {
    this.removeTouchListeners()
  }
  
  addTouchListeners() {
    if (this.hasCarouselTarget) {
      console.log('Adding touch listeners to carousel')
      this.carouselTarget.addEventListener('touchstart', this.handleTouchStart.bind(this), { passive: false })
      this.carouselTarget.addEventListener('touchmove', this.handleTouchMove.bind(this), { passive: false })
      this.carouselTarget.addEventListener('touchend', this.handleTouchEnd.bind(this), { passive: false })
      
      // Also add mouse events for testing on desktop
      this.carouselTarget.addEventListener('mousedown', this.handleMouseDown.bind(this))
      this.carouselTarget.addEventListener('mousemove', this.handleMouseMove.bind(this))
      this.carouselTarget.addEventListener('mouseup', this.handleMouseUp.bind(this))
    } else {
      console.error('Carousel target not found!')
    }
  }
  
  removeTouchListeners() {
    if (this.hasCarouselTarget) {
      this.carouselTarget.removeEventListener('touchstart', this.handleTouchStart.bind(this))
      this.carouselTarget.removeEventListener('touchmove', this.handleTouchMove.bind(this))
      this.carouselTarget.removeEventListener('touchend', this.handleTouchEnd.bind(this))
    }
  }
  
  handleTouchStart(e) {
    console.log('Touch start detected!')
    this.startX = e.touches[0].clientX
    this.isDragging = true
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transition = 'none'
    }
    console.log('Start X:', this.startX)
  }
  
  handleTouchMove(e) {
    if (!this.isDragging) return
    
    this.currentX = e.touches[0].clientX
    const diffX = this.currentX - this.startX
    const baseTranslateX = -this.currentSlide * 45
    const dragOffset = (diffX / window.innerWidth) * 45
    const translateX = baseTranslateX + dragOffset
    
    console.log('Touch move - diffX:', diffX, 'translateX:', translateX)
    
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transform = `translateX(${translateX}%)`
    }
  }
  
  handleTouchEnd(e) {
    if (!this.isDragging) return
    
    console.log('Touch end detected!')
    this.isDragging = false
    const diffX = this.currentX - this.startX
    const threshold = window.innerWidth * 0.2 // 20% of screen width
    
    console.log('Touch end - diffX:', diffX, 'threshold:', threshold)
    
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transition = 'transform 0.3s ease-in-out'
    }
    
    if (Math.abs(diffX) > threshold) {
      if (diffX > 0) {
        // Swipe right - go to previous slide
        console.log('Swipe right - going to previous slide')
        this.prev()
      } else {
        // Swipe left - go to next slide
        console.log('Swipe left - going to next slide')
        this.next()
      }
    } else {
      // Snap back to current slide
      console.log('Snap back to current slide')
      this.updateCarousel()
    }
  }
  
  // Mouse event handlers for desktop testing
  handleMouseDown(e) {
    console.log('Mouse down detected!')
    this.startX = e.clientX
    this.isDragging = true
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transition = 'none'
    }
  }
  
  handleMouseMove(e) {
    if (!this.isDragging) return
    
    this.currentX = e.clientX
    const diffX = this.currentX - this.startX
    const baseTranslateX = -this.currentSlide * 45
    const dragOffset = (diffX / window.innerWidth) * 45
    const translateX = baseTranslateX + dragOffset
    
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transform = `translateX(${translateX}%)`
    }
  }
  
  handleMouseUp(e) {
    if (!this.isDragging) return
    
    this.isDragging = false
    const diffX = this.currentX - this.startX
    const threshold = window.innerWidth * 0.2
    
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transition = 'transform 0.3s ease-in-out'
    }
    
    if (Math.abs(diffX) > threshold) {
      if (diffX > 0) {
        this.prev()
      } else {
        this.next()
      }
    } else {
      this.updateCarousel()
    }
  }
  
  next() {
    if (this.currentSlide < this.totalSlides - 1) {
      this.currentSlide++
    } else {
      this.currentSlide = 0 // Loop back to first slide
    }
    console.log('Next slide:', this.currentSlide)
    this.updateCarousel()
    this.updateIndicators()
  }
  
  prev() {
    if (this.currentSlide > 0) {
      this.currentSlide--
    } else {
      this.currentSlide = this.totalSlides - 1 // Loop to last slide
    }
    console.log('Previous slide:', this.currentSlide)
    this.updateCarousel()
    this.updateIndicators()
  }
  
  goToSlide(event) {
    this.currentSlide = parseInt(event.target.dataset.slide)
    this.updateCarousel()
    this.updateIndicators()
  }
  
  updateCarousel() {
    // Calculate translateX to show all images
    // With 7 images at 45% width each, total width is 315%
    // We need to scroll to show the last image (image 7)
    // Last slide should show images 6 and 7, so translateX = -4 * 45% = -180%
    const translateX = -this.currentSlide * 45 // 45% per slide since each image is 45% width
    console.log('Updating carousel - slide:', this.currentSlide, 'translateX:', translateX)
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transform = `translateX(${translateX}%)`
    }
    
    // Update slide counter
    const slideCounter = document.getElementById('current-slide')
    if (slideCounter) {
      slideCounter.textContent = this.currentSlide
    }
  }
  
  updateIndicators() {
    if (this.hasIndicatorTargets) {
      this.indicatorTargets.forEach((indicator, index) => {
        if (index === this.currentSlide) {
          indicator.classList.remove('bg-gray-300')
          indicator.classList.add('bg-gray-700')
        } else {
          indicator.classList.remove('bg-gray-700')
          indicator.classList.add('bg-gray-300')
        }
      })
    }
  }
  
  // Test method to manually move carousel
  testNext() {
    console.log('Test next called')
    this.next()
  }
  
  testPrev() {
    console.log('Test prev called')
    this.prev()
  }
}
