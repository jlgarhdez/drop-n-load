<?php

class Upload {
    const UPLOAD_FOLDER = 'uploads/';

    public function __construct()
    {
        
    }

}


$data = $_POST['data'];
$name = $_POST['name'];
$type = $_POST['type'];

$bin = base64_decode($data);
$success = file_put_contents(UPLOAD_FOLDER . $name, $bin);

$response = array();

if ($success !== FALSE) {
    $response['status'] = 'success';
    $response['filename'] = $name;
} else {
    $response['status'] = 'error';
    $response['error'] = 'unable to write file';
}

$upload = new Upload();

echo json_encode($response);

