import QRCode from 'qrcode'

const qrcode = {
  mounted() {
    window.addEventListener("phx:generate_qr_code", (event) => {
      const { detail } = event as CustomEvent
      const { text } = detail
      const canvas = document.getElementById('qrcode')

      QRCode.toCanvas(canvas, text, { width: 300 }, (error) => {
        if (error) console.error(error)
      })
    })
  }
}

export default qrcode