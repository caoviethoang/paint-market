import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['updateButton']

  setQuantityToZero(e) {
    const quantityId = e.params.quantityId // ✅ Stimulus tự map từ data-cart-page-quantity-id-param
    const input = document.getElementById(quantityId) // dùng getElementById nhanh hơn querySelector
    if (input) {
      input.value = '0'
      input.form.requestSubmit() // submit form ngay sau khi set về 0
    } else {
      console.warn("Không tìm thấy input với id:", quantityId)
    }
  }

  disableUpdateButton() {
    this.updateButtonTarget.setAttribute('disabled', true)
  }
}
