_check_cmd w3m
if test $? -eq 0; then
  w3m="`which -a w3m | egrep '^/' | head -1` -cookie -B -graph"

  alias w3m="${w3m}"
  alias google="${w3m} https://www.google.com/ncr"
  alias google-ja="${w3m} https://www.google.co.jp/"
  alias duckduckgo="${w3m} https://duckduckgo.com/"
  alias amazon="${w3m} https://www.amazon.com/"
  alias amazon-ja="${w3m} https://www.amazon.co.jp/"
  alias wikipedia="${w3m} http://en.wikipedia.org/"
  alias wikipedia-ja="${w3m} http://ja.wikipedia.org/"
  alias github="${w3m} https://github.com/"

  unset w3m
fi

