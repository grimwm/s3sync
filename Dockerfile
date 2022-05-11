FROM docker.io/fedora:35

WORKDIR /app

RUN dnf upgrade -y
RUN dnf install -y awscli inotify-tools
RUN dnf clean all

COPY entrypoint.sh /app
COPY sync.sh /app

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/sync.sh"]
