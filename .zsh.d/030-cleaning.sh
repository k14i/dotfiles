files_to_delete=("$HOME/.emacs.elc")
for f in "${files_to_delete[@]}"; do
  if test -f $f; then
    \rm $f
  fi
done

