_check_cmd say
if test $? -eq 0; then
  say="`which -a say | egrep '^/' | head -1` -r 200 --progress"

  alias say="${say}"
  alias say-agnes="${say} -v Agnes"
  alias say-jill="${say} -v Jill"
  alias say-kathy="${say} -v Kathy"
  alias say-princess="${say} -v Princess"
  alias say-samantha="${say} -v Samantha"
  alias say-vicki="${say} -v Vicki"
  alias say-victoria="${say} -v Victoria"
  alias say-alex="${say} -v Alex"
  alias say-bruce="${say} -v Bruce"
  alias say-fred="${say} -v Fred"
  alias say-junior="${say} -v Junior"
  alias say-ralph="${say} -v Ralph"
  alias say-tom="${say} -v Tom"
  alias say-albert="${say} -v Albert"
  alias say-bad_news="${say} -v Bad\ News"
  alias say-bahh="${say} -v Bahh"
  alias say-bells="${say} -v Bells"
  alias say-boing="${say} -v Boing"
  alias say-bubbles="${say} -v Bubbles"
  alias say-cellos="${say} -v Cellos"
  alias say-deranged="${say} -v Deranged"
  alias say-good_news="${say} -v Good\ News"
  alias say-hysterical="${say} -v Hysterical"
  alias say-pipe_organ="${say} -v Pipe\ Organ"
  alias say-trinoids="${say} -v Trinoids"
  alias say-whisper="${say} -v Whisper"
  alias say-zarbox="${say} -v Zarbox"
  alias say-kyoko="${say} -v Kyoko"

  unset say
fi

