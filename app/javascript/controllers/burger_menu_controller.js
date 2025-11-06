import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['modal']
  showing = false

  connect() {}

  toggle() {
    this.showing = !this.showing
    this.modalTarget.classList.toggle('hidden', !this.showing)
  }
}
