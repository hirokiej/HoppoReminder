import { Controller } from '@hotwired/stimulus'
import FullCalendar from 'fullcalendar'

export default class extends Controller {
  connect() {
    const calendar = new FullCalendar.Calendar(this.element, {
      initialView: 'dayGridMonth',
      events: '/calendars.json',
      height: 'auto'
    })
    calendar.render()
  }
}
