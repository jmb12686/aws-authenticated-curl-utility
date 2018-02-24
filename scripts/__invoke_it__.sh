#!/bin/bash

. $(dirname "$0")/__os_openssl__.sh
. $(dirname "$0")/__variables__.sh
. $(dirname "$0")/__sign_it__.sh

function invoke_it() {
    local method="$1"
    local authorization_header=$(sign_it "${method}")
    printf "> ${method}-ing ${api_url}\n"
    curl -si -X ${method} "${api_url}" -H "${authorization_header}" -H "${header_x_amz_date}"  -H "Content-Type: application/json" -d "${body_payload}"
}
