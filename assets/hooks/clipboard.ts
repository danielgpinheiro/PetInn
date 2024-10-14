const clipboard = {
  mounted() {
    window.addEventListener("pet_inn:clipboard", () => {
      const copyText = document.getElementById("text-to-clipboard") as HTMLInputElement

      copyText.select()
      copyText.setSelectionRange(0, 99999)
      navigator.clipboard.writeText(copyText.value || '')
    })
  }
}

export default clipboard