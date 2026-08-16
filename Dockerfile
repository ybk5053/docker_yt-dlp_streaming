FROM alpine:latest

RUN apk add --no-cache curl ca-certificate ffmpeg nginc fcgiwrap jq

WORKDIR /yt-dlp

ADD https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_musllinux ./yt-dlp
COPY entrypoint.sh ./entrypoint.sh
COPY default.conf /etc/nginx/http.d/default.conf
COPY yt-dl.sh /www/cgi-bin/yt-dl.sh
RUN chmod +x ./yt-dlp ./entrypoint.sh /www/cgi-bin/yt-dl.sh

ENTRYPOINT ["./entrypoint.sh"]
