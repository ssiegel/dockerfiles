#!/bin/sh

DEST="${1?destination directory not specified}"

generate_error_page() {
  NUM="$1"
  NAME="$2"
  TEXT="$3"
  echo "error_page ${NUM} //${NUM}.html; location = //${NUM}.html { internal; root \"${DEST}\"; try_files /${NUM}.html =${NUM}; }"

  cat > "${DEST}/${NUM}.html" <<EOT
<!DOCTYPE html>
<html>
<head>
  <title>${NAME} (${NUM})</title>
  <style>
    body {
      color: #666;
      text-align: center;
      font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
      margin:0;
      width: 800px;
      margin: auto;
      font-size: 14px;
    }
    h1 {
      font-size: 56px;
      line-height: 100px;
      font-weight: normal;
      color: #456;
    }
    h2 { font-size: 24px; color: #666; line-height: 1.5em; }
    h3 {
      color: #456;
      font-size: 20px;
      font-weight: normal;
      line-height: 28px;
    }
    hr {
      margin: 18px 0;
      border: 0;
      border-top: 1px solid #EEE;
      border-bottom: 1px solid white;
    }
  </style>
</head>
<body>
  <h1>${NUM}</h1>
  <h3>${NAME}.</h3>
  <hr/>
  <p>${TEXT}</p>
</body>
</html>
EOT
}

generate_error_page 500 "Internal Server Error" "The server encountered an internal error or misconfigurationand was unable to complete your request."
generate_error_page 502 "Bad Gateway" "The proxy server received an invalid response from an upstream server."
generate_error_page 503 "Service Temporarily Unavailable" "The server is temporarily unable to service your request due to maintenance downtime or capacity problems.<br/>Please try again later."
generate_error_page 504 "Gateway Time-out" "The proxy server did not receive a timely response from the upstream server."
generate_error_page 403 "Forbidden" "You don't have permission to access the requested resource on this server."
generate_error_page 404 "Not Found" "The requested resource was not found on this server."
