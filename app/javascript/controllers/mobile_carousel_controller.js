import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["carousel", "indicator"]
  
  connect() {
    this.currentSlide = 0
    this.totalSlides = 6 // 7 images but showing 2 at a time = 6 slides
    this.startX = 0
    this.currentX = 0
    this.isDragging = false
    
    this.updateCarousel()
    this.updateIndicators()
    this.addTouchListeners()
  }
  
  disconnect() {
    this.removeTouchListeners()
  }
  
  addTouchListeners() {
    const carousel = document.getElementById('mobile-carousel')
    if (carousel) {
      carousel.addEventListener('touchstart', this.handleTouchStart.bind(this), { passive: false })
      carousel.addEventListener('touchmove', this.handleTouchMove.bind(this), { passive: false })
      carousel.addEventListener('touchend', this.handleTouchEnd.bind(this), { passive: false })
    }
  }
  
  removeTouchListeners() {
    const carousel = document.getElementById('mobile-carousel')
    if (carousel) {
      carousel.removeEventListener('touchstart', this.handleTouchStart.bind(this))
      carousel.removeEventListener('touchmove', this.handleTouchMove.bind(this))
      carousel.removeEventListener('touchend', this.handleTouchEnd.bind(this))
    }
  }
  
  handleTouchStart(e) {
    this.startX = e.touches[0].clientX
    this.isDragging = true
    const carousel = document.getElementById('mobile-carousel')
    if (carousel) {
      carousel.style.transition = 'none'
    }
  }
  
  handleTouchMove(e) {
    if (!this.isDragging) return
    
    this.currentX = e.touches[0].clientX
    const diffX = this.currentX - this.startX
    const translateX = -this.currentSlide * 45 + (diffX / window.innerWidth) * 45
    
    const carousel = document.getElementById('mobile-carousel')
    if (carousel) {
      carousel.style.transform = `translateX(${translateX}%)`
    }
  }
  
  handleTouchEnd(e) {
    if (!this.isDragging) return
    
    this.isDragging = false
    const diffX = this.currentX - this.startX
    const threshold = window.innerWidth * 0.2 // 20% of screen width
    
    const carousel = document.getElementById('mobile-carousel')
    if (carousel) {
      carousel.style.transition = 'transform 0.3s ease-in-out'
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
    this.currentSlide = (this.currentSlide + 1) % this.totalSlides
    this.updateCarousel()
    this.updateIndicators()
  }
  
  prev() {
    this.currentSlide = (this.currentSlide - 1 + this.totalSlides) % this.totalSlides
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
    const carousel = document.getElementById('mobile-carousel')
    if (carousel) {
      carousel.style.transform = `translateX(${translateX}%)`
    }
  }
  
  updateIndicators() {
    const indicators = document.querySelectorAll('.carousel-indicator')
    indicators.forEach((indicator, index) => {
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
