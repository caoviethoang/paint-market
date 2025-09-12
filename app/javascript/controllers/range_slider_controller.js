import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["minHandle", "maxHandle"]
  static values = { 
    minValue: Number, 
    maxValue: Number, 
    currentMin: Number, 
    currentMax: Number 
  }

  connect() {
    this.isDragging = false
    this.dragTarget = null
    this.updateSlider()
  }

  startDrag(event) {
    this.isDragging = true
    this.dragTarget = event.target.getAttribute('role')
    document.addEventListener('mousemove', this.handleDrag.bind(this))
    document.addEventListener('mouseup', this.stopDrag.bind(this))
    event.preventDefault()
  }

  handleDrag(event) {
    if (!this.isDragging) return

    const rect = this.element.getBoundingClientRect()
    const percentage = Math.max(0, Math.min(100, ((event.clientX - rect.left) / rect.width) * 100))
    const value = this.minValueValue + (percentage / 100) * (this.maxValueValue - this.minValueValue)

    if (this.dragTarget === 'min-handle') {
      this.currentMinValue = Math.min(value, this.currentMaxValue - 1)
    } else if (this.dragTarget === 'max-handle') {
      this.currentMaxValue = Math.max(value, this.currentMinValue + 1)
    }

    this.updateSlider()
    this.updateInputs()
  }

  stopDrag() {
    this.isDragging = false
    this.dragTarget = null
    document.removeEventListener('mousemove', this.handleDrag.bind(this))
    document.removeEventListener('mouseup', this.stopDrag.bind(this))
  }

  updateSlider() {
    const minPercentage = ((this.currentMinValue - this.minValueValue) / (this.maxValueValue - this.minValueValue)) * 100
    const rangePercentage = ((this.currentMaxValue - this.currentMinValue) / (this.maxValueValue - this.minValueValue)) * 100

    const rangeBar = this.element.querySelector('.absolute.h-2.bg-blue-500')
    if (rangeBar) {
      rangeBar.style.left = `${minPercentage}%`
      rangeBar.style.width = `${rangePercentage}%`
    }
  }

  updateInputs() {
    const minInput = document.querySelector(`input[name*="${this.getScopeName()}_min"]`)
    const maxInput = document.querySelector(`input[name*="${this.getScopeName()}_max"]`)

    if (minInput) minInput.value = Math.round(this.currentMinValue)
    if (maxInput) maxInput.value = Math.round(this.currentMaxValue)
  }

  getScopeName() {
    // Extract scope name from the filter context
    // This would need to be passed from the component
    return 'height_range' // Default, should be dynamic
  }
}
