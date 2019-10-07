FROM alpine

RUN apk update && apk add curl

WORKDIR /stressor

COPY run .

ENTRYPOINT [ "sh", "run" ]
