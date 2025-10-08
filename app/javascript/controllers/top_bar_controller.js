import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['cartLink']
  static values = {
    cartUrl: { type: String, default: Solidus.pathFor('cart_link') }
  }

  connect() {
    console.log('Top bar controller connected');
    this.updateCartLink();
    this.setupFallbacks();
  }

  async updateCartLink() {
    try {
      const response = await fetch(this.cartUrlValue);
      if (response.ok) {
        this.cartLinkTarget.innerHTML = await response.text();
      } else {
        console.warn('Failed to update cart link:', response.status);
      }
    } catch (error) {
      console.error('Error updating cart link:', error);
      this.setupFallbackCartLink();
    }
  }

  setupFallbackCartLink() {
    // Create a simple fallback cart link if the fetch fails
    if (this.cartLinkTarget) {
      this.cartLinkTarget.innerHTML = `
        <a href="/cart" class="absolute top-0 left-0 w-full h-full block">
          <span class="sr-only">Cart</span>
        </a>
      `;
    }
  }

  setupFallbacks() {
    // Ensure cart link is clickable
    if (this.cartLinkTarget) {
      this.cartLinkTarget.addEventListener('click', (e) => {
        e.preventDefault();
        window.location.href = '/cart';
      });
    }
  }
}
