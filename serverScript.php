<?php

class Upload {

    /**
     * The default tmp folder
     */
    const TEMP_UPLOAD_FOLDER = 'tmp/';

    /**
     * The default upload destination folder
     */
    const UPLOAD_FOLDER = 'uploads/';

    /**
     * The current upload folder
     */
    private $uploadFolder;

    /**
     * The current temporary folder
     */
    private $tmpFolder;

    /**
     * An array of messages for returning to the user
     */
    private $messages = array(
        'success' => 'Success',
        'unable_to_write' => 'Unable to write file',
        'error_uploading_chunk' => 'Error uploading chunk',
        'unable_to_move_file' => 'Unable to move the file',
        'file_moved_successfully' => 'File moved successfully',
    );

    /**
     * The constructor. Takes 2 parameters, $uploads and $tmp. If any of them
     * are false, the upload will use the default path stored in
     * self::TEMP_UPLOAD_FOLDER or self::UPLOAD_FOLDER
     *
     * @param string $uploads The uploads folder
     * @param string $tmp     The temporary folder to upload the chunks or files
     */
    public function __construct($uploads, $tmp)
    {
        $this->uploadFolder =
            ($uploads != false)
            ? $uploads
            : self::UPLOAD_FOLDER;

        $this->tmpFolder=
            ($tmp != false)
            ? $tmp
            : self::TEMP_UPLOAD_FOLDER;

    }

    /**
     * This is the main method of the class. Takes a Temporary filename as
     * argument and returns an array with the status of the upload
     *
     * @param string $tmpFilename
     * @return Array
     */
    public function uploadFile($tmpFilename)
    {
        $response = array();

        $uploadedBlob = file_get_contents($_FILES['data']['tmp_name']);

        $success = file_put_contents(
            $this->tmpFolder . $tmpFilename,
            $uploadedBlob,
            FILE_APPEND
        );

        if ($success !== FALSE) {
            $response['tmpFilename'] = $tmpFilename;
            $response['status'] = $success;
        }else{
            $response['error'] = $this->messages['error_uploading_chunk'];
        }

        return $response;
    }

    /**
     * The method for moving files from $src to $dest
     *
     * @param string $src Source path
     * @param string $dest Destination path
     * @return Array An array with the status of the move operation
     */
    public function moveFile($src, $dest)
    {

        $status = copy( $this->tmpFolder . $src, $this->uploadFolder . $dest);

        if ($status) {
            unlink($this->tmpFolder . $src);
            $response['status'] = $this->messages['file_moved_successfully'];
        }else{
            $response['status'] = $this->messages['unable_to_move_file'];
            $response['origin'] = $this->tmpFolder . $src;
            $response['destination'] = $this->uploadFolder. $dest;
        }
        return $response;
    }
}

$uploadFolder = (isset($_POST['uploadFolder'])) ? $_POST['uploadFolder'] : FALSE;
$tmpFolder =    (isset($_POST['tmpFolder']))    ? $_POST['tmpFolder']    : FALSE;
$action =       (isset($_POST['action']))       ? $_POST['action']       : FALSE;
$filename =     (isset($_POST['filename']))     ? $_POST['filename']     : FALSE;
$type =         (isset($_POST['type']))         ? $_POST['type']         : FALSE;
$tmpFilename =
    (isset($_POST['tmpFilename']))
    ? $_POST['tmpFilename']
    : str_replace(
        array(' ', '.'),
        '',
        microtime()
    );

$upload = new Upload($uploadFolder, $tmpFolder);

switch ($action)
{
    case 'finish':
        $response = $upload->moveFile($tmpFilename, $filename);
    break;

    default:
        $response = $upload->uploadFile($tmpFilename);
    break;
}


echo json_encode($response);
