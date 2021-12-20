<?php

function removeBOM($str="") {
    if(substr($str, 0, 3) == pack('CCC', 0xef, 0xbb, 0xbf)) {
        $str = substr($str, 3);
    }
    return $str;
}

if (count($argv) == 1) {
  echo 'No parameters, need JSON-file';
  exit(1);
}

$fileName = $argv[1];

$JSON_in = file_get_contents($fileName);
if ($JSON_in === false) {
  echo 'Can not read file '.$fileName;
  exit(2);
}

$JSON_in = trim(removeBOM($JSON_in));

if (empty($JSON_in)) {
  echo 'File '.$fileName.' is empty';
  exit(3);
}

$jsonValue = json_decode($JSON_in);

if ($jsonValue === null) {
  echo 'JSON can not be decoded or null';
  exit(4);
}

$jsonPretty = json_encode($jsonValue, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);

if ($jsonPretty === false) {
  echo 'Can not encode to pretty JSON';
  exit(5);
}

file_put_contents($fileName, $jsonPretty);

?>