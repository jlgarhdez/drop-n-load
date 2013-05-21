<?php

class Upload {

    const TEMP_UPLOAD_FOLDER = 'tmp/';

    const UPLOAD_FOLDER = 'uploads/';

    private $uploadFolder;

    private $tmpFolder;

    public function __construct()
    {
    }

    public function uploadFile($filename, $data, $chunk)
    {
        $response = array($chunk);

        if ($chunk === FALSE) {
            $bin = base64_decode($data);

            $success = file_put_contents(self::UPLOAD_FOLDER . $filename, $bin);

            if ($success !== FALSE) {
                $response['status'] = 'success';
                $response['filename'] = $filename;
            } else {
                $response['status'] = 'error';
                $response['error'] = 'unable to write file';
            }

        } else {
            $tmpFilename = 
                (isset($_POST['tmpFilename'])) 
                ? $_POST['tmpFilename']
                : str_replace(
                    array(' ', '.'),
                    '',
                    microtime()
                );

            $uploadedBlob = file_get_contents($_FILES['data']['tmp_name']);

            $success = file_put_contents(
                self::TEMP_UPLOAD_FOLDER . $tmpFilename,
                $uploadedBlob,
                FILE_APPEND
            );

            $response['tmpFilename'] = $tmpFilename;
            $response['status'] = $success;
        }

        return $response;
    }

    public function moveFile($src, $dest)
    {
        $response = 'unable to move the file';
        if (copy($src, $dest)) {
            unlink($src);
            $response = 'file moved successfully';
        }
        return $response;
    }
}

$chunkIndex =   (isset($_POST['chunkIndex']))   ? $_POST['chunkIndex']   : FALSE;
$uploadFolder = (isset($_POST['uploadFolder'])) ? $_POST['uploadFolder'] : FALSE;
$tmpFolder =    (isset($_POST['tmpFolder']))    ? $_POST['tmpFolder']    : FALSE;

$name = $_POST['name'];
$data = $_POST['data'];
$type = $_POST['type'];

$action = (isset($_POST['action'])) ? $_POST['action'] : FALSE;
$tmpFilename = (isset($_POST['tmpFilename'])) ? $_POST['tmpFilename'] : FALSE;
$filename = (isset($_POST['filename'])) ? $_POST['filename'] : FALSE;

$upload = new Upload();

switch ($action) 
{
    case 'finish':
        $response = $upload->moveFile($tmpFilename, $filename);
    break;
  
    default:
        $response = $upload->uploadFile($name, $data, $chunkIndex);
    break;
}


echo json_encode($response);
