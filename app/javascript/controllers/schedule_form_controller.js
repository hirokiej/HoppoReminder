import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['startAt', 'message']
  static values = { originalStartAt: String }

  clearMessage() {
    this.messageTarget.classList.add('hidden')
  }

  warnMessage(event) {
    if (this.startAtTarget.value === this.originalStartAtValue) {
      event.preventDefault()
      event.stopImmediatePropagation()
      this.messageTarget.classList.remove('hidden')
    }
  }
}
