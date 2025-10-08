import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slides", "slide"]

  connect() {
    this.currentIndex = 0;
  }

  next() {
    if (this.currentIndex < this.slideTargets.length - 1) {
      this.currentIndex++;
    } else {
      this.currentIndex = 0; // Loop về đầu
    }
    this.scrollToSlide();
  }

  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex--;
    } else {
      this.currentIndex = this.slideTargets.length - 1; // Loop về cuối
    }
    this.scrollToSlide();
  }

  scrollToSlide() {
    const targetSlide = this.slideTargets[this.currentIndex];
    if (targetSlide) {
      targetSlide.scrollIntoView({
        behavior: 'smooth',
        block: 'nearest',
        inline: 'start'
      });
    }
  }
}
