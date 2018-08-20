# Fluentd/td-agent
FLUENTD_BIN=/usr/lib64/fluent/ruby/bin
if test -d ${FLUENTD_BIN}; then
  export PATH=$FLUENTD_BIN:$PATH
fi
unset FLUENTD_BIN

