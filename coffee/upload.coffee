class window.Upload

  # This will contain all the convenience configuration for the upload class.
  @settings =
    uploadScript: 'serverScript.php'
    files: DragAndDrop.files

  constructor: (@settings) ->

  # This method will handle the upload of each file
  uploadFile: (fileIndex) ->
    throw Error('fileIndex must be an integer') unless typeof fileIndex is 'number'

    file = Upload.settings.files[fileIndex]

    formData = new FormData
    formData.append 'data', file.dataUrl.split('base64,')[1] # Get only the dataString, not the header
    formData.append 'name', file.name
    formData.append 'type', file.type

    xhr = new XMLHttpRequest

    xhr.onload = (event) ->
      response = xhr.response

      if response.status == 'success'
        console.log 'success'

        if typeof Upload.settings.files[fileIndex + 1] isnt 'undefined'
          Upload.uploadFile files[fileIndex + 1]

      else
        console.log "error"
        

      @

    xhr.open 'POST', this.settings.uploadScript, true

    xhr.send(formData)
    @
