import { easepick } from "@easepick/core"
import { RangePlugin } from '@easepick/range-plugin'
import { AmpPlugin } from '@easepick/amp-plugin'
import { LockPlugin } from '@easepick/lock-plugin'

const ganttDatePicker = {
  mounted() {
    new easepick.create({
      element: document.getElementById('datepicker') as HTMLDivElement,
      css: [
          "https://cdn.jsdelivr.net/npm/@easepick/bundle@1.2.1/dist/index.css"
      ],
      lang: "pt-br",
      zIndex: 10,
      format: "DD/MM/YYYY",
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
        inseparable: false,
      },
      plugins: [
        AmpPlugin,
        RangePlugin,
        LockPlugin
      ]
    })
  }
}

export default ganttDatePicker