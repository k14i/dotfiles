AWS_RDS_HOME=$HOME'/bin/aws/cli/rds/current'
if test -d ${AWS_RDS_HOME}; then
  export AWS_RDS_HOME
  export PATH=$AWS_RDS_HOME'/bin':$PATH
  export EC2_REGION='ap-northeast-1'
  export AWS_CREDENTIAL_FILE=$HOME'/bin/aws/credential'
else
  unset AWS_RDS_HOME
fi

