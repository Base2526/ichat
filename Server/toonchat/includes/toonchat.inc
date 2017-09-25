<?php

/*
 * ปัญหาเกิดจาก function file_save_data() ต้อง call โดยใช้ services  global $user; จะไม่มี ค่า ทำให้ uid = 0 ดังนั้นเราจำเป้นต้อง copy  function file_save_data => function sati_file_save_data() เพือส่งค่า uid มาด้วย
*/
function sati_file_save_data($uid, $data, $destination = NULL, $replace = FILE_EXISTS_RENAME) {
  // global $user;

  if (empty($destination)) {
    $destination = file_default_scheme() . '://';
  }
  if (!file_valid_uri($destination)) {
    watchdog('file', 'The data could not be saved because the destination %destination is invalid. This may be caused by improper use of file_save_data() or a missing stream wrapper.', array('%destination' => $destination));
    drupal_set_message(t('The data could not be saved, because the destination is invalid. More information is available in the system log.'), 'error');
    return FALSE;
  }

  if ($uri = file_unmanaged_save_data($data, $destination, $replace)) {
    // Create a file object.
    $file = new stdClass();
    $file->fid = NULL;
    $file->uri = $uri;
    $file->filename = drupal_basename($uri);
    $file->filemime = file_get_mimetype($file->uri);
    $file->uid = $uid;//$user->uid;
    $file->status = FILE_STATUS_PERMANENT;
    // If we are replacing an existing file re-use its database record.
    if ($replace == FILE_EXISTS_REPLACE) {
      $existing_files = file_load_multiple(array(), array('uri' => $uri));
      if (count($existing_files)) {
        $existing = reset($existing_files);
        $file->fid = $existing->fid;
        $file->filename = $existing->filename;
      }
    }
    // If we are renaming around an existing file (rather than a directory),
    // use its basename for the filename.
    elseif ($replace == FILE_EXISTS_RENAME && is_file($destination)) {
      $file->filename = drupal_basename($destination);
    }

    return file_save($file);
  }
  return FALSE;
}


function ___test()
{
	return "test___";
}

?>