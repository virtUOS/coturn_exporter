FROM coturn/coturn:4

USER root:root

# https://techoverflow.net/2021/01/13/how-to-use-apt-install-correctly-in-your-dockerfile/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y python3 && rm -rf /var/lib/apt/lists/*

COPY --link --chmod=755 coturn_exporter /coturn_exporter_files/
RUN ln -st /usr/local/bin/ /coturn_exporter_files/coturn_exporter

USER nobody:nogroup

ENTRYPOINT []
CMD ["coturn_exporter"]

EXPOSE 80/tcp
