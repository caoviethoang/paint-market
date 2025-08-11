import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "image"]

  connect() {
    this.initialScale = 1;
    this.currentScale = 1;
  }

  open(event) {
    const imageUrl = event.currentTarget.dataset.lightboxUrl;
    this.imageTarget.src = imageUrl;
    this.modalTarget.classList.remove('hidden');
    document.body.style.overflow = 'hidden';

    // Reset scale khi mở modal
    this.currentScale = this.initialScale;
    this.imageTarget.style.transform = `scale(${this.currentScale})`;
  }

  close() {
    this.modalTarget.classList.add('hidden');
    this.imageTarget.src = '';
    document.body.style.overflow = 'auto';
  }

  closeBackground(event) {
    if (event.target === this.modalTarget) {
      this.close();
    }
  }

  // Phương thức zoom to
  zoomIn() {
    this.currentScale += 0.2; // Tăng scale thêm 0.2
    this.imageTarget.style.transform = `scale(${this.currentScale})`;
    this.imageTarget.style.transition = `transform 0.3s ease-in-out`;
  }

  // Phương thức zoom bé
  zoomOut() {
    if (this.currentScale > this.initialScale) {
      this.currentScale -= 0.2; // Giảm scale
      this.imageTarget.style.transform = `scale(${this.currentScale})`;
      this.imageTarget.style.transition = `transform 0.3s ease-in-out`;
    }
  }
}
