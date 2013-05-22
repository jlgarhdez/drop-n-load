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

  # This object contains all the convenience configuration for the upload class.
  @uploadSettings =
    uploadScript: 'serverScript.php'  # The script to send the data to. You can
                                      # use an URL here
    uploadFolder: 'uploads/'          # The uploads folder. Append the slash
    tempFolder: 'tmp/'                # Temporary folder. Append the slash
    chunkSize: 2000000                # ~2 MB
    maxUploadSize: 2000000000         # ~2 GB
    files: []                         # The array of File objects

  @currentFileSettings = {}

  constructor: (uploadSettings = null) ->
    if uploadSettings != null and
       typeof uploadSettings.uploadScript isnt undefined and
       typeof uploadSettings.uploadFolder isnt undefined and
       typeof uploadSettings.tmpFolder isnt undefined

      @uploadSettings = uploadSettings

    else

      @uploadSettings = Upload.uploadSettings

    @currentFileSettings =
      file: {}
      chunkIndex: 0
      numberOfChunks: 0
      tempName: null

  # This method will handle the upload of each file
  uploadFile: (fileIndex) =>
    throw Error('fileIndex must be an integer') unless typeof fileIndex is 'number'

    file = @uploadSettings.files[fileIndex]

    @uploadSettings.currentFileIndex = fileIndex

    parent = @

    # Calculate the number of chunks we should slice the file in
    size = @uploadSettings.chunkSize
    @currentFileSettings.numberOfChunks = Math.ceil file.size / size - 1
    @currentFileSettings.file = file
    @uploadChunk 0

    # Return this
    @


  uploadChunk: (chunkIndex, tmpFilename = null) =>
    parent = @

    # calculate the start and stop byte of the chunk
    start = chunkIndex * @uploadSettings.chunkSize
    stop = start + @uploadSettings.chunkSize

    # slice the chunk
    blob = @currentFileSettings.file.slice start, stop

    # Create the FileReader object
    reader = new FileReader
    reader.onloadend = (evt) ->
      if evt.target.readyState == FileReader.DONE
        formData = new FormData
        formData.append 'data', blob
        formData.append 'name', parent.currentFileSettings.file.name
        formData.append 'type', parent.currentFileSettings.file.type
        formData.append 'chunkIndex', chunkIndex
        formData.append 'tmpFilename', tmpFilename if tmpFilename != null

        xhr = new XMLHttpRequest
        xhr.onloadend = (event) ->
          response = JSON.parse xhr.response

          if parent.currentFileSettings.numberOfChunks > chunkIndex
            parent.uploadChunk ++chunkIndex, response.tmpFilename
          else
            parent.finishFileUpload response.tmpFilename

          @
        xhr.open 'POST', parent.uploadSettings.uploadScript, false
        xhr.send(formData)
        @

    reader.readAsBinaryString blob
    @

  finishFileUpload: (tmpFilename) =>

    parent = @

    formData = new FormData
    formData.append 'action', 'finish'
    formData.append 'tmpFilename', tmpFilename
    formData.append 'filename', @currentFileSettings.file.name

    # move the tmpFolder file to the uploads folder
    xhr = new XMLHttpRequest
    xhr.onloadend = (event) ->
      response = JSON.parse xhr.response
      if response.status == 'ok'
        currentFile = parent.currentFileSettings.file
        fileDiv = document.getElementById currentFile.name.replace /[^a-z0-9]/gi, ''
        fileDiv.setAttribute 'style', 'background-color: #5eb95e;'
      @
    xhr.open 'POST', @uploadSettings.uploadScript, false
    xhr.send formData

    # clean the currentFileSettings object
    if @uploadSettings.currentFileIndex + 1 <= @uploadSettings.files.length - 1

      # Increase by 1 the current file index
      @uploadSettings.currentFileIndex = @uploadSettings.currentFileIndex + 1

      # reset hte currentFileSettings object
      @currentFileSettings =
        file: {}
        chunkIndex: 0
        numberOfChunks: 0
        tempName: null

      @uploadFile @uploadSettings.currentFileIndex

  addFile: (file) =>
    @uploadSettings.files.push file
