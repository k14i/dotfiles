# _activate_venv(){
#   if [ -d .venv ]; then
#     source .venv/bin/activate
#   fi
# }

# case $KERNEL in
#   Darwin)
#     _check_cmd brew
#     if test $? -eq 0; then
#       export PYTHONPATH=$(brew --prefix)/lib/python2.7/site-packages
#     fi
#     ;;
#   Linux)
#     dir="/usr/local/lib/python3.3/site-packages"
#     if [ -d $dir ]; then
#       export PYTHONPATH=$dir
#     else
#       sudo mkdir -p $dir
#       export PYTHONPATH=$dir
#     fi
#     dir="/usr/local/lib/python2.7/site-packages"
#     if [ -d $dir ]; then
#       export PYTHONPATH=$dir
#     else
#       sudo mkdir -p $dir
#       export PYTHONPATH=$dir
#     fi
#     ;;
# esac

