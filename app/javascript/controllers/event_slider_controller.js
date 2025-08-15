import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track", "scrollbar", "thumb"]

  connect() {
    this.updateScrollbar()
    this.trackTarget.addEventListener("scroll", this.updateScrollbar.bind(this))
    window.addEventListener("resize", this.updateScrollbar.bind(this))
  }

  disconnect() {
    this.trackTarget.removeEventListener("scroll", this.updateScrollbar.bind(this))
    window.removeEventListener("resize", this.updateScrollbar.bind(this))
  }

  next() {
    const scrollAmount = this.trackTarget.offsetWidth
    this.trackTarget.scrollBy({
      left: scrollAmount,
      behavior: 'smooth'
    })
  }

  prev() {
    const scrollAmount = this.trackTarget.offsetWidth
    this.trackTarget.scrollBy({
      left: -scrollAmount,
      behavior: 'smooth'
    })
  }

  updateScrollbar() {
    const scrollWidth = this.trackTarget.scrollWidth
    const clientWidth = this.trackTarget.clientWidth
    const scrollLeft = this.trackTarget.scrollLeft

    // Tính toán kích thước và vị trí của thanh cuộn
    const thumbWidth = (clientWidth / scrollWidth) * 100
    const thumbPosition = (scrollLeft / scrollWidth) * 100
    
    this.thumbTarget.style.width = `${thumbWidth}%`
    this.thumbTarget.style.transform = `translateX(${thumbPosition}%)`
  }
}