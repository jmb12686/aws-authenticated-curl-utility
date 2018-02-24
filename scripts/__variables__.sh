#!/bin/bash

if [ "${__variables__}" = true ] ; then
    return 0
fi

. __utils__.sh

## parse arguments

until [ $# -eq 0 ]; do
  name=${1:1}; shift;
  if [[ -z "$1" || $1 == -* ]] ; then eval "export $name=''"; else eval "export $name=$1"; shift; fi
done

if [ -z "${credentials}" ] || [ -z "${url}" ]; then
    log "sample usage:" "<script> -credentials <aws_access_key>:<aws_secret_key> -url <c_url>"
    log "OPTIONAL:" "body <body_payload>"
    log "OPTIONAL:" "region <user_aws_region>"
	log "OPTIONAL:" "service <user_aws_service>"
    exit 1
fi

readonly aws_access_key=$(cut -d':' -f1 <<<"${credentials}")
readonly aws_secret_key=$(cut -d':' -f2 <<<"${credentials}")
readonly api_url="${url}"
readonly body_payload="${body}"
readonly user_aws_region="${region}"
readonly user_aws_service="${service}"
log "aws_access_key=" "${aws_access_key}"
log "aws_secret_key=" "${aws_secret_key}"
log "api_url=" "${url}"
log "body_payload=" "${body_payload}"
log "user_aws_region=" "${user_aws_region}"
log "user_aws_service" "${user_aws_service}"

readonly timestamp=${timestamp-$(date -u +"%Y%m%dT%H%M%SZ")} #$(date -u +"%Y%m%dT%H%M%SZ") #"20171226T112335Z"
readonly today=${today-$(date -u +"%Y%m%d")}  # $(date -u +"%Y%m%d") #20171226
log "timestamp=" "${timestamp}"
log "today=" "${today}"

readonly api_host=$(printf ${api_url} | awk -F/ '{print $3}')
readonly api_uri=$(printf ${api_url} | grep / | cut -d/ -f4-)

if [ ! -z "$user_aws_region" ]; then
	readonly aws_region="${user_aws_region}"
else	
	readonly aws_region=$(cut -d'.' -f3 <<<"${api_host}")
fi

if [ ! -z "$user_aws_service" ]; then
	readonly aws_service="${user_aws_service}"
else
	readonly aws_service=$(cut -d'.' -f2 <<<"${api_host}")
fi

readonly algorithm="AWS4-HMAC-SHA256"
readonly credential_scope="${today}/${aws_region}/${aws_service}/aws4_request"

readonly signed_headers="content-type;host;x-amz-date"
readonly header_x_amz_date="x-amz-date:${timestamp}"
readonly header_content_type="content-type:application/json"
#readonly 

__variables__=true
