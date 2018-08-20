case $KERNEL in
  Darwin)
    if [ -f /opt/local/bin/trash ] || [ -f /usr/local/bin/trash ]; then
      alias rm="trash"
    elif [ -f /opt/local/bin/rmtrash ] || [ -f /usr/local/bin/rmtrash ]; then
      alias rm="rmtrash"
    elif [ -f /opt/local/bin/gmv ] || [ -f /usr/local/bin/gmv ]; then
      alias rm="gmv -f --backup=numbered --target-directory /tmp/rm/`date +%Y-%m-%d`"
    else
      alias rm="rm -i"
    fi
    ;;
  Linux)
    if [ -f /usr/bin/trash ]; then
      alias rm="trash"
    else
      alias rm="mv -f --backup=numbered --target-directory /tmp/rm/`date +%Y-%m-%d`"
    fi
    ;;
  *)
    rm="rm -i"
    ;;
esac

