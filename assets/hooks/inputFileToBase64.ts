let self

const inputFileToBase64 = {
  mounted() {
    self = this
    manageEventListenerToAllInputFiles('remove')

    setTimeout(() => {
      manageEventListenerToAllInputFiles('add')
    }, 10)
  },
  updated() {
    self = this
    manageEventListenerToAllInputFiles('remove')

    setTimeout(() => {
      manageEventListenerToAllInputFiles('add')
    }, 10)
  }
}

const manageEventListenerToAllInputFiles = (type: string) => {
  const inputs = document.querySelectorAll('.file-input')

  inputs.forEach((input) => {
    type === 'add' ? input.addEventListener('change', onChangeFileInput) : input.removeEventListener('change', onChangeFileInput)
  })
}

const onChangeFileInput = async (params) => {
  const element = params.target.getAttribute('data-element')
  const index = params.target.getAttribute('data-index')

  const file = params.target.files[0]
  const size = file.size
  const sizeInMb = Math.round(size / 1024)

  if (sizeInMb > 1024) {
    self.pushEventTo("#pet-step", "file_too_big", null)

    return
  }

  const base64 = await convertBase64(file)
  self.pushEventTo("#pet-step", "change_form_element", {
    base64,
    element,
    index
  })
}

const convertBase64 = (file) => {
  return new Promise((resolve, reject) => {
    const fileReader = new FileReader()
    fileReader.readAsDataURL(file)

    fileReader.onload = () => {
      resolve(fileReader.result)
    }

    fileReader.onerror = (error) => {
      reject(error)
    }
  })
}

export default inputFileToBase64