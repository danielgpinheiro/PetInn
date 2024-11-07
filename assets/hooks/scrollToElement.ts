const scrollToElement = {
  mounted() {
    window.addEventListener("phx:scroll_to_element", (event) => {
      const { detail } = event as CustomEvent
      const { element, top, left, behavior, fade_wizard } = detail
      const elementDOM = document.querySelector<HTMLElement>(element)
      const wizardContentElement = document.querySelector('.wizard-animate-content')

      if (fade_wizard) {
        setTimeout(() => {
          wizardContentElement?.classList.add('fadeInLeft')
        }, 10)

        setTimeout(() => {
          wizardContentElement?.classList.remove('fadeInLeft')
        }, 600)
      }
      
      if (elementDOM) {
        elementDOM.scrollTo({
          top,
          left,
          behavior,
        })
      }
    });
  },
};

export default scrollToElement
