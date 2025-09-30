FROM ubuntu:latest

RUN apt-get update -y && apt-get install jq wget -y && apt-get clean

WORKDIR /opt/app
COPY scheduler.sh /opt/app
RUN wget https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && chmod +x ttyd.x86_64
RUN chmod +x scheduler.sh

ENTRYPOINT ["./ttyd.x86_64", "-p", "7681", "-W", "./scheduler.sh"]
