####################################################
# GOLANG BUILDER
####################################################
FROM golang:1.11 as go_builder

COPY . /go/src/github.com/malice-plugins/zoner
WORKDIR /go/src/github.com/malice-plugins/zoner
RUN go get -u github.com/golang/dep/cmd/dep && dep ensure
RUN go build -ldflags "-s -w -X main.Version=v$(cat VERSION) -X main.BuildTime=$(date -u +%Y%m%d)" -o /bin/avscan

####################################################
# IMPORT OLD DATABASE
####################################################

FROM malice/zoner:0.1.0

COPY --from=go_builder /bin/avscan /bin/avscan

WORKDIR /malware

ENTRYPOINT ["/bin/avscan"]
CMD ["--help"]