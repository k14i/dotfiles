_check_cmd diskutil
if test $? -eq 0; then
  alias diskutil-mountDisk="diskutil mountDisk"
  alias diskutil-unmountDisk="diskutil unmountDisk"
  alias diskutil-list="diskutil list"
  alias diskutil-eject="diskutil eject"
fi

