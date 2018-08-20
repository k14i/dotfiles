# https://github.com/sferik/t
_check_cmd t
if test $? -eq 0; then
  alias tw="$GEM_HOME/bin/t"
  alias tw-update="tw update"
  alias tw-timeline="tw timeline"
  alias tw-stream-timeline="tw stream timeline"
fi

