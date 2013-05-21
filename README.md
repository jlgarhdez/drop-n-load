Simple Upload
=============

> Disclaimer
> This is a simple project whose principal purpose is learning Coffeescript.
> I will try to mantain it, but only try.

Simple upload is a drag and drop based upload helper. Is written in
Coffeescript, and the important files are in the `coffee/` dir. There are two
coffee files:

Configuration
-------------
###index.html
You can configure Simple-upload from index.html. Just create a new script tag
after including dragandrop.js and upload.js with the following:

```javascript
// Initialize Upload object
window.upload = new Upload({
	uploadScript: 'serverScript.php',
	uploadFolder: 'uploads/',
	tempFolder: 'tmp/',
	chunkSize: 200000,
	maxUploadSize: 2000000000,
	files: []
});

// Initialize Drag and Drop object
window.dragAndDrop = new DragAndDrop({
	droppableContainerId: 'droppable-container',
	borderStyleOnDragover: '6px dashed #444',
	uploadButtonId: 'upload-button',
	droppablePlaceholderId: 'droppable-placeholder'
});

function fire() {
	upload.uploadFile(0);
}
```

###dragandrop.coffee
This is the file that handles the events for drag and drop. It is ready for
using the next settings:

```coffeescript
@settings =
  droppableContainerId: 'droppable-container'     #the id of the div where we will drop the files in
  borderStyleOnDragover: '6px dashed #444'        #The style for the border of the div while in the dragover event
  uploadButtonId: 'upload-button'                 #the id of the upload button
  droppablePlaceholderId: 'droppable-placeholder' # the id of the message "drop your files here"
```

###upload.coffee
this is the file that handles the upload. When instancing the class, pass it an
object like this:

```coffee
uploadSettings =
  uploadScript: 'serverScript.php' # The url of the script to send the data to
  uploadFolder: 'uploads/'         # upload folder
  tempFolder: 'tmp/'               # temp folder
  chunkSize: 200000                # Size of each chunk. ~2MB
  maxUploadSize: 2000000000        # Max file size to upload. ~2GB
  files: []                        # Empty array of files
```

Instructions:
-------------
First of all, you have to create the upload and temp folders and give them
permissions:

```bash
mkdir uploads
mkdir tmp
chmod 755 uploads
chmod 755 tmp
```

For generating the js files, do the following:

```bash
cd wherever-you-have-cloned-the-project
coffee --compile --output js/ coffee/
```
