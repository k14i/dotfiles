_check_cmd rsync
if test $? -eq 0; then
  rsync="`which -a rsync | egrep '^/' | head -1` -a -S --delay-updates --exclude-from=$HOME/.rsync/exclude.txt --stats -E"

  alias rsync="${rsync}"
  alias rsync-local="${rsync} -v --progress --rsh='rsh'"
  alias rsync-local-quiet="${rsync} -q --ignore-errors --rsh='rsh'"
  alias rsync-standard="${rsync} -vz --progress"
  alias rsync-standard-quiet="${rsync} -zq --ignore-errors"
  alias rsync-full="${rsync} \
    -vz \
    --progress \
    -b \
    --backup-dir=$HOME/.backup/rsync \
    --suffix=.`date +%Y%m%d%H%M%S` \
    --ignore-errors \
    --partial \
    --partial-dir=$HOME/tmp/.rsync/partial \
    -T $HOME/tmp/.rsync/temp \
    --log-file=$HOME/var/log/rsync/`date +%Y%m%d%H%M%S`.log"
  alias rsync-full-local="${rsync} \
    --rsh='rsh' \
    -v \
    --progress \
    -b \
    --backup-dir=$HOME/.backup/rsync \
    --suffix=.`date +%Y%m%d%H%M%S` \
    --ignore-errors \
    --partial \
    --partial-dir=$HOME/tmp/.rsync/partial \
    -T $HOME/tmp/.rsync/temp \
    --log-file=$HOME/var/log/rsync/`date +%Y%m%d%H%M%S`.log"
  alias rsync-full-quiet="${rsync} \
    -zq \
    -b \
    --backup-dir=$HOME/.backup/rsync \
    --suffix=.`date +%Y%m%d%H%M%S` \
    --ignore-errors \
    --partial \
    --partial-dir=$HOME/tmp/.rsync/partial \
    -T $HOME/tmp/.rsync/temp \
    --log-file=$HOME/var/log/rsync/`date +%Y%m%d%H%M%S`.log"
  alias rsync-full-local-quiet="${rsync} \
    --rsh='rsh' \
    -q \
    -b \
    --backup-dir=$HOME/.backup/rsync \
    --suffix=.`date +%Y%m%d%H%M%S` \
    --ignore-errors \
    --partial \
    --partial-dir=$HOME/tmp/.rsync/partial \
    -T $HOME/tmp/.rsync/temp \
    --log-file=$HOME/var/log/rsync/`date +%Y%m%d%H%M%S`.log"

  unset rsync
fi

