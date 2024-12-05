import LottieWeb from 'lottie-web'

const lottie = {
  mounted() {
    const lottieContainers = document.querySelectorAll("[data-lottie]")

    lottieContainers.forEach(container => {
      const animationName = container.getAttribute('data-lottie')

      LottieWeb.loadAnimation({
        container,
        renderer: 'svg',
        loop: true,
        autoplay: true,
        path: `/images/lottie/${animationName}.json`
      })
    })
  }
}

export default lottie