#!/bin/bash

# 脚本的日志文件
LOGFILE="/var/log/zabbix/sms.log"
:>"$LOGFILE"
exec 1>"$LOGFILE"
exec 2>&1


# 手机号码
MOBILE_NUMBER=$1
# 短信内容
MESSAGE_UTF8=$2
XXD="/usr/bin/xxd"
CURL="/usr/bin/curl"
TIMEOUT=5

# 短信内容要经过URL编码处理，除了下面这种方法，也可以用curl的--data-urlencode选项实现。
MESSAGE_ENCODE=$(echo "$MESSAGE_UTF8" | ${XXD} -ps | sed 's/\(..\)/%\1/g' | tr -d '\n')

URL="http://10.90.2.118:7003/dps_mi/smsCommon.do?responseFormat=JSON&smsRecipient=${MOBILE_NUMBER}&smsText=${MESSAGE_ENCODE}"



# Send it
set -x
${CURL} -s --connect-timeout ${TIMEOUT} "${URL}"
