GLUSTERFS=/usr/local/glusterfs
if test -d ${GLUSTERFS}; then
  export PATH=${GLUSTERFS}/sbin:$PATH
  export MANPATH=$MANPATH:${GLUSTERFS}/share/man
fi
unset GLUSTERFS

GLUSTERFS_SBIN=/usr/local/glusterfs/sbin
if test -d ${GLUSTERFS_SBIN}; then
  export PATH=${GLUSTERFS_SBIN}:$PATH
fi
unset GLUSTERFS_SBIN

