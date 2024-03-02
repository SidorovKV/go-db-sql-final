FROM golang:1.22-alpine3.19 AS builder

WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o app .

# second stage, release with only the binary
FROM alpine:3.19

# create user other than root
RUN addgroup -g 111 app && \
    adduser -H -u 111 -G app -s /bin/sh -D app

# place all necessary executables and other files into /app directory
WORKDIR /app/
COPY --from=builder --chown=app:app app .

# run container as new non-root user
USER app

CMD ["./app"]