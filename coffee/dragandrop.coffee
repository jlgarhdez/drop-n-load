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

class window.DragAndDrop

  # Default settings for the work of the uploader. You can change it
  @settings =
    droppableContainerId: 'droppable-container'
    borderStyleOnDragover: '6px dashed #444'
    uploadButtonId: 'upload-button'
    droppablePlaceholderId: 'droppable-placeholder'

  # Reference to the droppable container
  @container = {}

  # This constructor binds the handler to the events
  constructor: (settings) ->

    if typeof settings is 'object'
      @settings = settings

    # Initialize the container element
    DragAndDrop.container = document.getElementById DragAndDrop.settings.droppableContainerId

    # Add the listeners for the drag and drop events
    DragAndDrop.container.addEventListener 'drop',      @dropHandler
    DragAndDrop.container.addEventListener 'dragover',  @dragOverHandler
    DragAndDrop.container.addEventListener 'dragleave', @dragLeaveHandler

  # DragOver handler
  dragOverHandler: (event) ->
    event.preventDefault()
    DragAndDrop.container.style.border = DragAndDrop.settings.borderStyleOnDragover
    @

  # DragOver handler
  dragLeaveHandler: (event) ->
    DragAndDrop.container.style.border = "none"
    @

  # Drop handler
  dropHandler: (event) ->
    event.preventDefault()

    # The array of files
    files = event.dataTransfer.files

    # loop through the array of files
    DragAndDrop.prototype.proccessFile file for file in files
    DragAndDrop.container.style.border = "none"
    @

  # Method for processing each file 
  proccessFile: (file) ->
    reader = new FileReader

    reader.onload = (onloadendEvent) ->
      dataUrl = this.result

      file.dataUrl = dataUrl

      # Add the file to the array
      upload.addFile file

      fileDiv = document.createElement 'div'

      if file.type.match 'image.*'
        imageElement = document.createElement 'img'
        imageElement.setAttribute 'src', dataUrl
        imageElement.setAttribute 'class', 'thumb'

        fileDiv.appendChild imageElement

      filenameElement = document.createElement 'span'
      filenameElement.innerHTML = file.name

      fileDiv.appendChild filenameElement

      DragAndDrop.container.appendChild fileDiv

      placeholder =  document.getElementById DragAndDrop.settings.droppablePlaceholderId

      DragAndDrop.container.removeChild placeholder if placeholder isnt null
      @

    reader.readAsDataURL file
