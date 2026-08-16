CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
    echo "-- First container startup --"
    # YOUR_JUST_ONCE_LOGIC_HERE
    apk add curl ca-certificate nginx ffmpeg fcgiwrap --no-cache
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_musllinux -o ./yt-dlp
    chmod +x ./yt-dlp
else
    echo "-- Not first container startup --"
fi

fcgiwrap -f -s tcp:127.0.0.1:9000 &
nginx -g 'daemon off;'
