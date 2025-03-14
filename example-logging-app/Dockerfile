FROM alpine:3.7

RUN apk add --no-cache bash

COPY app.sh /
RUN chmod +x /app.sh

ENTRYPOINT ["/app.sh"]
