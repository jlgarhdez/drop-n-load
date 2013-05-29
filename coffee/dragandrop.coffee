###
This class will contain all the logic for the drag and drop operations. 
author José Luis García <jl.garhdez@gmail.com>
version 0.1
###
class window.DragAndDrop

  # Default settings for the work of the uploader. You can change it here or in
  # the call to the constructor
  @settings =
    droppableContainerId: 'droppable-container'
    borderStyleOnDragover: '6px dashed #444'
    uploadButtonId: 'upload-button'
    droppablePlaceholderId: 'droppable-placeholder'

  # Reference to the droppable container
  @container = {}

  # this constructor binds each event to each handler
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
  dropHandler: (event) =>
    event.preventDefault()

    # The array of files
    files = event.dataTransfer.files

    # loop through the array of files
    @proccessFile file for file in files
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
      fileDiv.setAttribute 'class', 'file'
      fileDiv.setAttribute 'id', file.name.replace /[^a-z0-9]/gi, ''

      # Checks if the file is an image to show a thumbnail
      if file.type.match 'image.*'
        imageElement = document.createElement 'img'
        imageElement.setAttribute 'src', dataUrl
        imageElement.setAttribute 'class', 'thumb'
        fileDiv.appendChild imageElement

      filenameElement = document.createElement 'span'
      filenameElement.innerHTML = file.name

      fileDiv.appendChild filenameElement
      placeholder =  document.getElementById DragAndDrop.settings.droppablePlaceholderId

      DragAndDrop.container.appendChild fileDiv
      DragAndDrop.container.removeChild placeholder if placeholder isnt null
      @

    reader.readAsDataURL file
