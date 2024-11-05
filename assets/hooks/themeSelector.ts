const themeSelector = {
  mounted() {
    const lightSwitches = document.querySelectorAll('.light-switch') as unknown as HTMLInputElement[]

    if (localStorage.getItem('dark-mode') === 'true' || (!('dark-mode' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
      document.querySelector('html')?.classList.add('dark')
      document.querySelector('html')?.classList.add('ec-dark')
    } else {
      document.querySelector('html')?.classList.remove('dark')
      document.querySelector('html')?.classList.remove('ec-dark')
    }

    if (lightSwitches.length > 0) {
      lightSwitches.forEach((lightSwitch, i) => {
        if (localStorage.getItem('dark-mode') === 'true') {
          lightSwitch.checked = true
        }

        console.log(lightSwitch)

        lightSwitch.addEventListener('change', () => {
          const {
            checked
          } = lightSwitch

          lightSwitches.forEach((el, n) => {
            if (n !== i) {
              el.checked = checked
            }
          })

          if (lightSwitch.checked) {
            document.documentElement.classList.add('dark')
            localStorage.setItem('dark-mode', "true")
          } else {
            document.documentElement.classList.remove('dark')
            localStorage.setItem('dark-mode', "false")
          }
        })
      })
    }
  }
}

export default themeSelector

