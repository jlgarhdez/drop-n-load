<?php

class Upload {

    const TEMP_UPLOAD_FOLDER = 'tmp/';

    const UPLOAD_FOLDER = 'uploads/';

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

            // Do all the chunked stuff

        }

        return $response;
    }
}


$name = $_POST['name'];
$data = $_POST['data'];
$type = $_POST['type'];
$chunkIndex = (isset($_POST['chunkIndex'])) ? $_POST['chunkIndex'] : FALSE;
$uploadFolder = (isset($_POST['uploadFolder'])) ? $_POST['uploadFolder'] : FALSE;
$tmpFolder = (isset($_POST['tmpFolder'])) ? $_POST['tmpFolder'] : FALSE;

//$upload = new Upload();

//$response = $upload->uploadFile($name, $data, $chunkIndex);

//echo json_encode($response);
echo json_encode($_POST);
