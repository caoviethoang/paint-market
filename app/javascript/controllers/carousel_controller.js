import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slides", "slide", "scrollbar"]

  connect() {
    this.currentIndex = 0;
    this.showSlide();
    this.updateScrollbar()
  }

  next() {
    this.currentIndex = (this.currentIndex < this.slideTargets.length - 1) ? this.currentIndex + 1 : 0;
    this.showSlide();
    this. updateScrollbar();
  }

  prev() {
    this.currentIndex = (this.currentIndex > 0) ? this.currentIndex - 1 : this.slideTargets.length - 1;
    this.showSlide();
    this. updateScrollbar();
  }

  goToSlide(event) {
    this.currentIndex = parseInt(event.currentTarget.dataset.carouselIndex, 10);
    this.showSlide();
    this. updateScrollbar();
  }

  showSlide() {
    const slideWidth = this.slideTargets[0].offsetWidth;
    this.slidesTarget.style.transform = `translateX(${-this.currentIndex * slideWidth}px)`;
  }

  updateScrollbar() {
    if (!this.hasThumbTarget) return // tránh lỗi nếu chưa render
    const ratio = (this.currentIndex + 1) / this.slideTargets.length
    this.thumbTarget.style.width = `${ratio * 100}%`
  }

  prevThumbnails() {
    this.thumbnailContainerTarget.scrollBy({
      left: -100, // Điều chỉnh giá trị cuộn
      behavior: 'smooth'
    });
  }

  nextThumbnails() {
    this.thumbnailContainerTarget.scrollBy({
      left: 100, // Điều chỉnh giá trị cuộn
      behavior: 'smooth'
    });
  }
}
