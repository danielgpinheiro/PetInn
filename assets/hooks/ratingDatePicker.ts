import { easepick } from "@easepick/core"
import { RangePlugin } from '@easepick/range-plugin'
import { AmpPlugin } from '@easepick/amp-plugin'
import { LockPlugin } from '@easepick/lock-plugin'
import { TimePlugin } from '@easepick/time-plugin'

const ratingDatePicker = {
  mounted() {
    new easepick.create({
      element: document.getElementById('datepicker') as HTMLDivElement,
      css: [
          "https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css"
      ],
      lang: "pt-br",
      zIndex: 10,
      format: "DD/MM/YYYY HH:mm",
      readonly: false,
      autoApply: false,
      locale: {
        cancel: "Cancelar",
        apply: "Confirmar"
      },
      AmpPlugin: {
        dropdown: {
          months: true,
          years: true
        },
        darkMode: false
      },
      RangePlugin: {
        locale: {
          one: "dia",
          other: "dias"
        },
        delimiter: ' até '
      },
      LockPlugin: {
        selectForward: true,
        inseparable: true,
        minDate: new Date(),
        minDays: 2
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

export default ratingDatePicker