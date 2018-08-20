_check_cmd gtags
if test $? -eq 0; then
  export MAKEOBJDIRPREFIX=$HOME/devel/.gtags
  alias mkgtags='mkdir -p $MAKEOBJDIRPREFIX/$(pwd -P) && gtags -i $MAKEOBJDIRPREFIX/$(pwd -P)'
  alias mkgtags-cpp='GTAGSFORCECPP=1 $(maketags)'
fi

