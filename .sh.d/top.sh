case $KERNEL in
  Darwin)
    alias top="top -s1 -o cpu -R -F"
    alias topu="top -U $LOCAL_ID"
    ;;
  Linux)
    alias top="top -d 1"
    alias topu="top -U $LOCAL_ID"
    ;;
esac

