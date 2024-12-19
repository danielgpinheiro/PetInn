import { easepick } from "@easepick/core"
import { RangePlugin } from '@easepick/range-plugin'
import { AmpPlugin } from '@easepick/amp-plugin'
import { LockPlugin } from '@easepick/lock-plugin'
import { TimePlugin } from '@easepick/time-plugin'
import { DateTime } from '@easepick/datetime'

const bookedDates = [
  ['2024-12-01', '2024-12-24'],
  '2024-12-27'
].map((d) => {
  if (d instanceof Array) {
    const start: DateTime = new DateTime(d[0], 'YYYY-MM-DD');
    const end: DateTime = new DateTime(d[1], 'YYYY-MM-DD');

    return [start, end];
  }

  return new DateTime(d, 'YYYY-MM-DD');
})

const confirmDatePicker = {
  mounted() {
    new easepick.create({
      element: document.getElementById('datepicker') as HTMLDivElement,
      css: [
        "https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css"
      ],
      lang: setCalendarLanguage().lang,
      zIndex: 10,
      format: setCalendarLanguage().format,
      readonly: false,
      autoApply: false,
      locale: {
        cancel: setCalendarLanguage().cancelButton,
        apply: setCalendarLanguage().confirmButton
      },
      AmpPlugin: {
        dropdown: {
          months: true,
          years: true
        },
        darkMode: setDarkModeCalendar()
      },
      RangePlugin: {
        locale: {
          one: setCalendarLanguage().rangeOne,
          other: setCalendarLanguage().rangeOthers
        },
        delimiter: setCalendarLanguage().rangeDelimiter
      },
      LockPlugin: {
        selectForward: true,
        inseparable: true,
        minDate: new Date(),
        minDays: 2,
        filter(date, picked) {
          if (picked.length === 1) {
            //@ts-ignore
            const incl = date.isBefore(picked[0]) ? '[)' : '(]';

            return (
              //@ts-ignore
              !picked[0].isSame(date, 'day') && date.inArray(bookedDates, incl)
            );
          }

          //@ts-ignore
          return date.inArray(bookedDates, '[)');
        }
      },
      TimePlugin: {
        stepMinutes: 30
      },
      plugins: [
        AmpPlugin,
        RangePlugin,
        LockPlugin,
        TimePlugin
      ]
    })
  }
}

const setCalendarLanguage = () => {
  const queryString = window.location.search
  const urlParams = new URLSearchParams(queryString)
  const locale = urlParams.get('locale')

  const languages = (locale: string | null) => {
    const langs = {
      'pt_BR': 'pt-br',
      'en': 'en-us',
      'es': 'es'
    }

    const format = {
      'pt_BR': 'DD/MM/YYYY HH:mm',
      'en': 'MM-DD-YYYY HH:mm',
      'es': 'D de MMMM de YYYY HH:mm'
    }

    const cancelButton = {
      'pt_BR': 'Cancelar',
      'en': 'Cancel',
      'es': 'Cancelar'
    }

    const confirmButton = {
      'pt_BR': 'Confirmar',
      'en': 'OK',
      'es': 'Confirmar'
    }

    const rangeOne = {
      'pt_BR': 'dia',
      'en': 'day',
      'es': 'día'
    }

    const rangeOthers = {
      'pt_BR': 'dias',
      'en': 'days',
      'es': 'días'
    }

    const rangeDelimiter = {
      'pt_BR': ' até ',
      'en': ' to the ',
      'es': ' al '
    }

    return {
      lang: locale ? langs[locale] : 'pt-br',
      format: locale ? format[locale] : 'DD/MM/YYYY HH:mm',
      cancelButton: locale ? cancelButton[locale] : 'Cancelar',
      confirmButton: locale ? confirmButton[locale] : 'Confirmar',
      rangeOne: locale ? rangeOne[locale] : 'dia',
      rangeOthers: locale ? rangeOthers[locale] : 'dias',
      rangeDelimiter: locale ? rangeDelimiter[locale] : ' até ',
    }
  }

  return languages(locale)
}

const setDarkModeCalendar = () => {
  const isDarkMode = window.localStorage.getItem('dark-mode') === 'true'

  return isDarkMode
}

export default confirmDatePicker