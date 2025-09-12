import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon", "trigger"]

  connect() {
    // Content is already hidden by default in the HTML
    // No need to call hideContent() here
  }

  toggle() {
    if (this.isVisible()) {
      this.hideContent()
    } else {
      this.showContent()
    }
  }

  showContent() {
    this.contentTarget.classList.remove("hidden")
    // Change icon from + to -
    this.iconTarget.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 12h12"></path>'
  }

  hideContent() {
    this.contentTarget.classList.add("hidden")
    // Change icon from - to +
    this.iconTarget.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>'
  }

  isVisible() {
    return !this.contentTarget.classList.contains("hidden")
  }
}
