const triggerButton = {
  mounted() {
    window.addEventListener('phx:trigger_button', (event) => {
      const { detail } = event as CustomEvent
      const { button_id } = detail

      document.getElementById(button_id)?.click()
    })
  }
}

export default triggerButton

