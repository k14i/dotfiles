LOCAL_ID=`whoami`
SSH_SECRET_KEY="${HOME}/.ssh/id_rsa"
KERNEL=`uname -s`

case $KERNEL in
  Darwin)
    HOME_PARENT_DIR="/Users"
    ;;
  Linux)
    HOME_PARENT_DIR="/home"
    ;;
esac

