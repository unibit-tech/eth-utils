FROM ethereum/client-go:latest

WORKDIR /root

RUN apk add --no-cache --update git bash curl wait4ports jq

ADD run.sh run.sh

RUN chmod u+x run.sh

ENTRYPOINT /root/run.sh