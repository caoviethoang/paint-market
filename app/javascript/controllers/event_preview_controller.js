// app/javascript/controllers/event_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["details"]

  show(e) {
    // e.preventDefault() là dòng quan trọng nhất để ngăn hành vi mặc định
    e.preventDefault() 
    fetch(e.currentTarget.href)
      .then(r => {
        if (!r.ok) {
          throw new Error("Network response was not ok " + r.statusText);
        }
        return r.text();
      })
      .then(html => {
        this.detailsTarget.innerHTML = html;
      })
      .catch(error => {
        console.error("There was a problem with the fetch operation:", error);
      });
  }
}