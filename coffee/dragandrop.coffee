###
MIT License

This is a simple drop'n'upload implementation for see the power of Coffeescript

Copyright (c) 2013 José Luis García
###

class window.DragAndDrop

  # Default settings for the work of the uploader. You can change it
  @settings =
    droppableContainerId: 'droppable-container'
    borderStyleOnDragover: '6px dashed #444'
    uploadButtonId: 'upload-button'
    droppablePlaceholderId: 'droppable-placeholder'

  @container = {}

  @files = []

  # This constructor binds the handler to the events
  constructor: ->

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
    for file in files

      # check if the file is an image or not, for displaying a thumbnail
      reader = new FileReader

      # This callback will be executed when the readAsDataURL operation
      # finishes
      reader.onloadend = (event) ->
        dataUrl = this.result

        file.dataUrl = dataUrl
        DragAndDrop.files.push file

        if file.type.match 'image.*'
          img = document.createElement 'img'
          img.setAttribute 'src', dataUrl
          img.setAttribute 'style', 'width: 100px; height: 100px'
          DragAndDrop.container.appendChild img

      reader.readAsDataURL file

    DragAndDrop.container.style.border = "none"
    @

# Instance of the class.
dragAndDrop = new DragAndDrop
