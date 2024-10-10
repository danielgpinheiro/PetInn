const scrollToElement = {
  mounted() {
    window.addEventListener("phx:scrollTo-element", (event) => {
      const { detail } = event
      const { element } = detail
      const elementDOM = document.querySelector<HTMLElement>(element)
      const wizardContentElement = document.querySelector('.wizard-animate-content')

      setTimeout(() => {
        wizardContentElement?.classList.add('fadeInLeft')
      }, 10)

      setTimeout(() => {
        wizardContentElement?.classList.remove('fadeInLeft')
      }, 600)
      
      if (elementDOM) {
        elementDOM.scrollTop = 0
      }
    });
  },
};

export default scrollToElement
