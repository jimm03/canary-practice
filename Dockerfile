FROM ubuntu:latest

RUN apt-get update -y && \
    apt-get install -y jq ttyd && \
    apt-get clean

WORKDIR /opt/app

COPY scheduler.sh /opt/app/

RUN chmod +x scheduler.sh

# Directory for persistence
VOLUME ["/opt/app/data"]

# Expose ttyd web terminal
EXPOSE 7681

# Run script via ttyd so it’s web accessible
CMD ["ttyd", "-p", "7681", "bash", "/opt/app/scheduler.sh"]

