import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['modal']
  showing = false

  connect() {}

  toggle() {
    this.showing = !this.showing
    this.modalTarget.classList.toggle('hidden', !this.showing)
  }

  clickOutside(e) {
    if (e.target === e.currentTarget) {
      console.log('oooooooooo')
      return this.toggle()
    }
  }
}
