const scrollToElement = {
  mounted() {
    window.addEventListener("phx:scrollTo-element", (event) => {
        const { detail } = event
        const { element } = detail
        const elementDOM = document.querySelector<HTMLElement>(element)
        
        if (elementDOM) {
          elementDOM.scrollTop = 0
        }
    });
  },
};

export default scrollToElement
