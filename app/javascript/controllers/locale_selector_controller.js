import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['selector']

  connect() {
    console.log('Locale selector controller connected');
    this.setupFallback();
  }

  submitForm() {
    try {
      console.log('Attempting to submit locale form');
      if (this.selectorTarget && this.selectorTarget.form) {
        console.log('Form found, submitting...');
        this.selectorTarget.form.submit();
      } else {
        console.error('Form or selector target not found');
        this.fallbackSubmit();
      }
    } catch (error) {
      console.error('Error submitting locale form:', error);
      this.fallbackSubmit();
    }
  }

  switchLocale(event) {
    const selectedLocale = event.target.value;
    console.log('Locale change event:', selectedLocale);
    if (selectedLocale) {
      try {
        this.submitForm();
      } catch (error) {
        console.error('Error in switchLocale:', error);
        this.fallbackSubmit();
      }
    }
  }

  fallbackSubmit() {
    const selectedLocale = this.selectorTarget?.value;
    if (selectedLocale) {
      console.log('Using fallback submission for locale:', selectedLocale);
      // Try to find the form manually
      const form = this.element.querySelector('form');
      if (form) {
        console.log('Found form manually, submitting');
        form.submit();
      } else {
        console.log('No form found, redirecting directly');
        window.location.href = `/locale/set?switch_to_locale=${selectedLocale}`;
      }
    }
  }

  setupFallback() {
    // Ensure the select element has a change event listener
    if (this.selectorTarget) {
      this.selectorTarget.addEventListener('change', (e) => {
        console.log('Direct change event on selector');
        this.switchLocale(e);
      });
    }
  }
}
