FROM ubuntu:22.04

ARG TARGETARCH

WORKDIR /app/

RUN apt update && apt install -y curl gpg lsb-release

RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
RUN apt update && apt install -y cloudflare-warp

RUN curl -L "https://github.com/ginuerzh/gost/releases/download/v2.12.0/gost-linux-${TARGETARCH}-2.12.0.gz" -o gost.gz && gzip -d /app/gost.gz && chmod +x /app/gost

RUN rm /app/gost.gz

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 1080

CMD [ "/bin/bash", "/app/start.sh" ]
