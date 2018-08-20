_check_cmd go
if test $? -eq 0; then
  GOROOT=/usr/lib/go
  if test -d ${GOROOT}; then
    export GOROOT=${GOROOT}
  fi
  GOPATH=$HOME/.golang
  if test -d ${GOPATH}; then
    export GOPATH=${GOPATH}
  fi
  if test -d ${GOROOT} && test -d ${GOPATH}; then
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
  fi
  if test ! -d $GOPATH; then
    mkdir -p $GOPATH/bin
  fi
fi

