import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "check", "border"]

  connect() {
    this.update()
  }

  update() {
    if (this.inputTarget.checked) {
      this.checkTarget.classList.remove("hidden")
      this.borderTarget.classList.add("border-indigo-600")
    } else {
      this.checkTarget.classList.add("hidden")
      this.borderTarget.classList.remove("border-indigo-600")
    }
  }
}
