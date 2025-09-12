import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["propertySelect", "valueSelect", "valueInput"]
  static values = { 
    propertiesUrl: String,
    valuesUrl: String 
  }

  connect() {
    console.log("Property Values Controller connected")
  }

  propertyChanged() {
    const propertyId = this.propertySelectTarget.value
    const valueSelect = this.valueSelectTarget
    const valueInput = this.valueInputTarget

    // Clear existing options
    valueSelect.innerHTML = '<option value="">Select a value...</option>'
    valueInput.value = ""

    if (propertyId) {
      this.loadPropertyValues(propertyId)
    }
  }

  async loadPropertyValues(propertyId) {
    try {
      const response = await fetch(`${this.valuesUrlValue}/${propertyId}`)
      const data = await response.json()
      
      const valueSelect = this.valueSelectTarget
      
      // Add options from property values
      data.values.forEach(value => {
        const option = document.createElement('option')
        option.value = value.value
        option.textContent = value.display_name
        valueSelect.appendChild(option)
      })
      
      // Show select if there are values, otherwise show input
      if (data.values.length > 0) {
        valueSelect.style.display = 'block'
        valueInput.style.display = 'none'
      } else {
        valueSelect.style.display = 'none'
        valueInput.style.display = 'block'
      }
      
    } catch (error) {
      console.error('Error loading property values:', error)
      // Fallback to input field
      this.valueSelectTarget.style.display = 'none'
      this.valueInputTarget.style.display = 'block'
    }
  }

  valueChanged() {
    const valueSelect = this.valueSelectTarget
    const valueInput = this.valueInputTarget
    
    if (valueSelect.style.display !== 'none') {
      valueInput.value = valueSelect.value
    }
  }
}
