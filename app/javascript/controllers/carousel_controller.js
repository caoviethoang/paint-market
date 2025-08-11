import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slides", "slide", "thumbnail", "thumbnailContainer"]

  connect() {
    this.currentIndex = 0;
    this.showSlide();
  }

  next() {
    this.currentIndex = (this.currentIndex < this.slideTargets.length - 1) ? this.currentIndex + 1 : 0;
    this.showSlide();
  }

  prev() {
    this.currentIndex = (this.currentIndex > 0) ? this.currentIndex - 1 : this.slideTargets.length - 1;
    this.showSlide();
  }

  goToSlide(event) {
    this.currentIndex = parseInt(event.currentTarget.dataset.carouselIndex, 10);
    this.showSlide();
  }

  showSlide() {
    const slideWidth = this.slideTargets[0].offsetWidth;
    this.slidesTarget.style.transform = `translateX(${-this.currentIndex * slideWidth}px)`;
    this.updateThumbnails();
    this.scrollThumbnails(); // Thêm dòng này
  }

  updateThumbnails() {
    this.thumbnailTargets.forEach((thumb, index) => {
      if (index === this.currentIndex) {
        thumb.classList.add('border-blue-500');
        thumb.classList.remove('border-transparent');
      } else {
        thumb.classList.remove('border-blue-500');
        thumb.classList.add('border-transparent');
      }
    });
  }

  // Logic cuộn ngang cho thumbnails
  scrollThumbnails() {
    const thumbnailWidth = this.thumbnailTargets[0].offsetWidth;
    const thumbnailContainer = this.thumbnailContainerTarget;
    const thumbnailGap = 8; // Tương ứng với gap-2 của Tailwind

    const scrollPosition = this.currentIndex * (thumbnailWidth + thumbnailGap);
    thumbnailContainer.scroll({
      left: scrollPosition,
      behavior: 'smooth'
    });
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
