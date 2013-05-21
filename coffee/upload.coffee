###
Copyright (c) 2013 José Luis García <jl.garhdez@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
###

class window.Upload

  # This will contain all the convenience configuration for the upload class.
  @uploadSettings =
    uploadScript: 'serverScript.php'  # The script to send the data to. You can
                                      # use an URL here
    uploadFolder: 'uploads/'          # The uploads folder. Append the slash
    tempFolder: 'tmp/'                # Temporary folder. Append the slash
    chunkSize: 2000000                # ~2 MB
    maxUploadSize: 2000000000         # ~2 GB
    files: []                         # The array of File objects

  @currentFileSettings = {}

  constructor: (uploadSettings) ->
    if typeof uploadSettings.uploadScript isnt undefined and
       typeof uploadSettings.uploadFolder isnt undefined and
       typeof uploadSettings.tmpFolder isnt undefined
      @uploadSettings = uploadSettings

      @currentFileSettings =
        file: {}
        chunkIndex: 0
        numberOfChunks: 0
        tempName: null

  # This method will handle the upload of each file
  uploadFile: (fileIndex) =>
    throw Error('fileIndex must be an integer') unless typeof fileIndex is 'number'

    file = @uploadSettings.files[fileIndex]
    parent = @

    if file.size < @uploadSettings.chunkSize # It is not necesary to split the file

      # This object holds all the elements
      formData = new FormData
      formData.append 'data', file.dataUrl.split('base64,')[1] # Get only the dataString, not the header
      formData.append 'name', file.name
      formData.append 'type', file.type

      # Create the AJAX to upload the file
      xhr = new XMLHttpRequest
      xhr.onload = (event) ->
        response = JSON.parse xhr.response
        if response.status == 'success'
          if typeof Upload.uploadSettings.files[fileIndex + 1] isnt 'undefined'
            parent.uploadFile fileIndex + 1
        else
          console.log "error"
        @
      xhr.open 'POST', this.uploadSettings.uploadScript, true
      xhr.send(formData)
      @
    else # the file is bigger than the max chunk size, so we have to split it

      # Calculate the number of chunks we should slice the file in
      size = @uploadSettings.chunkSize
      @currentFileSettings.numberOfChunks = Math.ceil file.size / size - 1
      @currentFileSettings.file = file
      @uploadChunk 0

    # Return this
    @


  uploadChunk: (chunkIndex) =>
    parent = @
    start = chunkIndex * @uploadSettings.chunkSize
    stop = start + @uploadSettings.chunkSize

    console.log chunkIndex

    blob = @currentFileSettings.file.slice start, stop

    reader = new FileReader
    reader.onloadend = (evt) ->
      if evt.target.readyState == FileReader.DONE
        formData = new FormData
        formData.append 'data', evt.target.result, 'asdf'
        formData.append 'name', parent.currentFileSettings.file.name
        formData.append 'type', parent.currentFileSettings.file.type
        formData.append 'chunkIndex', chunkIndex

        xhr = new XMLHttpRequest
        xhr.onloadend = (event) ->
          response = xhr.response
          console.log response

          if parent.currentFileSettings.numberOfChunks > chunkIndex
            parent.uploadChunk ++chunkIndex

          @
        xhr.open 'POST', parent.uploadSettings.uploadScript, false
        xhr.send(formData)
        @

    reader.readAsBinaryString blob
    @

  addFile: (file) =>
    @uploadSettings.files.push file
