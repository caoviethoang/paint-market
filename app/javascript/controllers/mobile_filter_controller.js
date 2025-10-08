import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "sidebar"]

  toggle() {
    this.modalTarget.classList.toggle('hidden')
    this.sidebarTarget.classList.toggle('translate-x-full')
  }
}
