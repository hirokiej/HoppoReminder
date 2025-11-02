import { Controller } from '@hotwired/stimulus'
import FullCalendar from 'fullcalendar'

export default class extends Controller {
  connect() {
    const calendar = new FullCalendar.Calendar(this.element, {
      initialView: 'dayGridMonth',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,listWeek'
      },
      events: '/calendars.json'
    })
    calendar.render()
  }
}
