const locale = {
  mounted() {
    window.addEventListener('phx:save_locale', (event) => {
      const { detail } = event as CustomEvent
      const { locale } = detail

      let url = new URL(window.location.toString())
      let params = new URLSearchParams(url.search)

      params.set("locale", locale)

      window.location.search = params.toString()
    })
  }
}

export default locale

