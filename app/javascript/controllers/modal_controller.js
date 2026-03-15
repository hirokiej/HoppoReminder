import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['modal']

  connect() {
    this.element.addEventListener('turbo:before-fetch-request', () =>
      this.open()
    )
    this.element.addEventListener('turbo:submit-end', (event) => {
      if (event.detail.success) {
        this.close()
      }
    })
  }

  open() {
    this.element.classList.remove('hidden')
  }
  close() {
    this.element.classList.add('hidden')
  }

  disable(event) {
    const button = event.currentTarget
    setTimeout(() => {
      button.disabled = true
      button.value = '保存中...'
    }, 100)
  }
}
