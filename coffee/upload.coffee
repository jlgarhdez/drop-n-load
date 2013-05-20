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
    uploadScript: 'serverScript.php'  # The script to send the data to
    uploadFolder: 'uploads/'          # The uploads folder. Append the slash, plz
    tempFolder: 'tmp/'                # Temporary folder. Append the slash, plz
    chunkSize: 2000000                # ~2 MB
    maxUploadSize: 2000000000         # ~2 GB
    files: []                         # The array of File objects

  @currentUpload =
    chunkIndex: 0
    tempName: null

  constructor: (@uploadSettings) ->

  # This method will handle the upload of each file
  uploadFile: (fileIndex) =>
    throw Error('fileIndex must be an integer') unless typeof fileIndex is 'number'
    file = Upload.uploadSettings.files[fileIndex]
    parent = @

    if file.size < @uploadSettings.chunkSize
      formData = new FormData
      formData.append 'data', file.dataUrl.split('base64,')[1] # Get only the dataString, not the header
      formData.append 'name', file.name
      formData.append 'type', file.type

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
    else
      # Calculate the number of chunks
      # loop over this number
      # 

  setFiles: (files) =>
    @uploadSettings.files = files

  getFiles: () ->
    @uploadSettings.files

