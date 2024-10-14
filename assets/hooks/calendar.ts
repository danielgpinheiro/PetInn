import Calendar from '@event-calendar/core';
import TimeGrid from '@event-calendar/time-grid';
import DayGrid from '@event-calendar/day-grid'
import List from '@event-calendar/list'

const calendar = {
  mounted() {
    const ec = new Calendar({
      target: document.getElementById('calendar'),
      props: {
        plugins: [TimeGrid, DayGrid, List],
        options: {
          height: '100%',
          headerToolbar: {
            start: 'prev,next today',
            center: 'title',
            end: 'dayGridMonth,timeGridWeek,timeGridDay'
          },
          buttonText: {
            today: 'Hoje',
            dayGridMonth: 'Mês',
            timeGridDay: 'Dia',
            timeGridWeek: 'Semana'
          },
          allDaySlot: false,
          view: 'dayGridMonth',
          locale: 'pt-BR',
          eventClick: (event) =>{
            console.log(event)
          },
          events: [
            {
              id: "1230993",
              start: new Date(),
              end: new Date("2024-10-18"),
              title: {html: '<strong>Sonic Golden</strong> Daniel Pinheiro'},
              backgroundColor: 'orange'
            }
          ]
        }
      }
    })
  }
}

export default calendar