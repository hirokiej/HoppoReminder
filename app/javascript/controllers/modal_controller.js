import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['modal']

  connect() {
    this.element.addEventListener('turbo:before-fetch-request', () =>
      this.open()
    )
  }

  open() {
    this.element.classList.remove('hidden')
  }
  close() {
    this.element.classList.add('hidden')
  }
}
