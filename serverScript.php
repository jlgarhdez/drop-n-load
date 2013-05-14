<?php

define('UPLOAD_FOLDER', 'uploads/');

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

echo json_encode($response);
