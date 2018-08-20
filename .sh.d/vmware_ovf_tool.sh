VMWARE_OVF_TOOL=/Applications/VMware\ OVF\ Tool
if test -d ${VMWARE_OVF_TOOL}; then
  export PATH=${VMWARE_OVF_TOOL}:$PATH
fi
unset VMWARE_OVF_TOOL

