import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["carousel", "indicator"]
  
  connect() {
    this.currentSlide = 0
    this.totalSlides = 6 // 7 images but showing 2 at a time = 6 slides (0-5)
    this.startX = 0
    this.currentX = 0
    this.isDragging = false
    
    console.log('Mobile carousel connected, total slides:', this.totalSlides)
    this.updateCarousel()
    this.updateIndicators()
    this.addTouchListeners()
  }
  
  disconnect() {
    this.removeTouchListeners()
  }
  
  addTouchListeners() {
    if (this.hasCarouselTarget) {
      this.carouselTarget.addEventListener('touchstart', this.handleTouchStart.bind(this), { passive: false })
      this.carouselTarget.addEventListener('touchmove', this.handleTouchMove.bind(this), { passive: false })
      this.carouselTarget.addEventListener('touchend', this.handleTouchEnd.bind(this), { passive: false })
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
    this.startX = e.touches[0].clientX
    this.isDragging = true
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transition = 'none'
    }
  }
  
  handleTouchMove(e) {
    if (!this.isDragging) return
    
    this.currentX = e.touches[0].clientX
    const diffX = this.currentX - this.startX
    const translateX = -this.currentSlide * 45 + (diffX / window.innerWidth) * 45
    
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transform = `translateX(${translateX}%)`
    }
  }
  
  handleTouchEnd(e) {
    if (!this.isDragging) return
    
    this.isDragging = false
    const diffX = this.currentX - this.startX
    const threshold = window.innerWidth * 0.2 // 20% of screen width
    
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transition = 'transform 0.3s ease-in-out'
    }
    
    if (Math.abs(diffX) > threshold) {
      if (diffX > 0) {
        // Swipe right - go to previous slide
        this.prev()
      } else {
        // Swipe left - go to next slide
        this.next()
      }
    } else {
      // Snap back to current slide
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
    const translateX = -this.currentSlide * 45 // 45% per slide since each image is 45% width
    console.log('Updating carousel - slide:', this.currentSlide, 'translateX:', translateX)
    if (this.hasCarouselTarget) {
      this.carouselTarget.style.transform = `translateX(${translateX}%)`
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
}
