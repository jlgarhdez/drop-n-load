Simple Upload
=============

> Disclaimer
> This is a simple project whose principal purpose is learning Coffeescript.
> I will try to mantain it, but only try.

Simple upload is a drag and drop based upload helper. Is written in
Coffeescript, and the important files are in the `coffee/` dir. There are two
coffee files:

dragandrop.coffee
-----------------
This is the file that handles the events for drag and drop. It is ready for
using the next settings:

```coffeescript
@settings =
  droppableContainerId: 'droppable-container' #the id of the div where we will drop the files in
  borderStyleOnDragover: '6px dashed #444' #The style for the border of the div while in the dragover event
  uploadButtonId: 'upload-button' #the id of the upload button
  droppablePlaceholderId: 'droppable-placeholder' # the id of the message "drop your files here"
```

upload.coffee
-------------
this is the file that handles the upload. When instancing the class, pass it an
object like this:

```coffee
uploadSettings =
  uploadScript: 'serverScript.php'
  files: DragAndDrop.files
```



Instructions:
-------------
For generating the js files, do the following:

```bash
cd wherever-you-have-cloned-the-project
coffee --compile --output js/ coffee/
```
