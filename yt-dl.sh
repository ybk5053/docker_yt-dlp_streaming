#!/bin/sh

if [ "$REQUEST_METHOD" = "POST" ] && [ -n "$CONTENT_LENGTH" ]; then
    POST_DATA=$(dd bs=1 count="$CONTENT_LENGTH" 2>/dev/null)
    URL_VAL=$(echo "$POST_DATA" | jq -r '.url')
    REF_VAL=$(echo "$POST_DATA" | jq -r '.referer // "unknown"')
    # 2. Check if either key is missing ("null") or empty
    if [ "$URL_VAL" = "null" ] || [ -z "$URL_VAL" ]; then
        echo "Status: 400 Bad Request"
        echo "Content-Type: application/json"
        echo ""
        echo '{"status": "error", "message": "Missing required key: url"}'
        exit 0
    fi
    /root/yt-dlp -o - --impersonate Chrome-116 --referer "$REF_VAL" "$URL_VAL" | ffmpeg -re -i pipe:0 -c copy -f mpegts -listen 1 http://0.0.0.0:12345 >/root/log 2>&1 </dev/null &
    echo "Status: 200 OK"
    echo "Content-Type: application/json"
    echo ""
    cat << EOF
{
  "status": "success",
  "message": "JSON received",
  "extracted": {
    "url": "$URL_VAL",
    "referer": "$REF_VAL"
  }
}
EOF
else
    echo "Status: 405 Method Not Allowed"
    echo "Content-Type: application/json"
    echo ""
    echo '{"status": "error", "message": "Only POST requests allowed"}'
fi
