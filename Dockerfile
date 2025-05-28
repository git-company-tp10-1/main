FROM ubuntu:latest
LABEL authors="Owl"

ENTRYPOINT ["top", "-b"]