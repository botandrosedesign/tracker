import { Controller } from "@hotwired/stimulus"
import useActions from "stimulus-use-actions"

export default class extends Controller {
  static targets = [
    "checkbox",
    "permanent",
  ]

  open(event) {
    if(event.target.closest(".state-actions")) return
    if(event.target.classList.contains(".initials")) return
    this.checkboxTarget.checked = true
    this.permanentTargets.forEach(e => e.setAttribute("data-turbo-permanent", "true"))
  }

  close(event) {
    this.checkboxTarget.checked = false
    this.permanentTargets.forEach(e => e.removeAttribute("data-turbo-permanent"))
  }
}
