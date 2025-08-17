import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image"]
  static values = { 
    preloadCount: { type: Number, default: 3 },
    lazyLoadThreshold: { type: Number, default: 0.1 }
  }

  connect() {
    this.initializeImageLoading()
    this.setupIntersectionObserver()
  }

  disconnect() {
    if (this.intersectionObserver) {
      this.intersectionObserver.disconnect()
    }
  }

  initializeImageLoading() {
    // Preload first 3 images immediately
    this.imageTargets.slice(0, this.preloadCountValue).forEach(img => {
      this.loadImage(img)
    })

    // Setup lazy loading for remaining images
    this.imageTargets.slice(this.preloadCountValue).forEach(img => {
      img.setAttribute('loading', 'lazy')
    })
  }

  setupIntersectionObserver() {
    this.intersectionObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            const img = entry.target
            this.loadImage(img)
            this.intersectionObserver.unobserve(img)
          }
        })
      },
      {
        threshold: this.lazyLoadThresholdValue,
        rootMargin: '50px'
      }
    )

    // Observe images that are not preloaded
    this.imageTargets.slice(this.preloadCountValue).forEach(img => {
      this.intersectionObserver.observe(img)
    })
  }

  loadImage(img) {
    if (img.complete) {
      this.onImageLoad(img)
    } else {
      img.addEventListener('load', () => this.onImageLoad(img))
      img.addEventListener('error', () => this.onImageError(img))
    }
  }

  onImageLoad(img) {
    img.classList.add('loaded')
    
    // Remove placeholder animation
    const container = img.closest('div')
    if (container) {
      const placeholder = container.querySelector('.animate-pulse')
      if (placeholder) {
        placeholder.classList.add('opacity-0')
        setTimeout(() => {
          placeholder.remove()
        }, 300)
      }
    }
  }

  onImageError(img) {
    console.warn(`Failed to load image: ${img.src}`)
    
    // Show fallback content
    const container = img.closest('.image-container')
    if (container) {
      container.innerHTML = `
        <div class="w-full h-full bg-gradient-to-br from-gray-200 to-gray-300 flex items-center justify-center">
          <span class="text-gray-500 text-sm font-medium">Image Error</span>
        </div>
      `
    }
  }

  // Preload next image when user hovers over current image
  preloadOnHover(event) {
    const currentImg = event.currentTarget
    const currentIndex = parseInt(currentImg.dataset.imageIndex)
    const nextIndex = currentIndex + 1
    
    if (nextIndex <= 7) {
      const nextImg = this.imageTargets.find(img => 
        parseInt(img.dataset.imageIndex) === nextIndex
      )
      
      if (nextImg && nextImg.getAttribute('loading') === 'lazy') {
        nextImg.setAttribute('loading', 'eager')
        this.loadImage(nextImg)
      }
    }
  }
}
