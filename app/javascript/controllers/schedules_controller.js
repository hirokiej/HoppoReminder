import { Controller } from '@hotwired/stimulus'
import { Turbo } from '@hotwired/turbo-rails'

export default class extends Controller {
  static targets = ['select']

  changeStudent() {
    const studentId = this.selectTarget.value
    if (studentId) {
      Turbo.visit(`/students/${studentId}/schedules`, {
        frame: 'student_schedules'
      })
    }
  }
}
