FROM docker.io/coturn/coturn:4

USER root:root

# https://techoverflow.net/2021/01/13/how-to-use-apt-install-correctly-in-your-dockerfile/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y python3 python3-venv && rm -rf /var/lib/apt/lists/*

RUN mkdir --mode=755 /coturn_exporter_files

RUN python3 -m venv /coturn_exporter_files/venv
RUN /coturn_exporter_files/venv/bin/pip install --no-cache-dir --upgrade pip
COPY --chmod=644 requirements.txt /coturn_exporter_files/
RUN /coturn_exporter_files/venv/bin/pip install --no-cache-dir -r /coturn_exporter_files/requirements.txt

COPY --chmod=755 coturn_exporter /coturn_exporter_files/
RUN ln -st /usr/local/bin/ /coturn_exporter_files/coturn_exporter

USER nobody:nogroup

ENTRYPOINT ["coturn_exporter"]
CMD []

EXPOSE 9524/tcp
