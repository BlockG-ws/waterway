FROM debian:bookworm-slim

ARG TARGETARCH

WORKDIR /app/

RUN apt update && apt install -y curl gpg lsb-release

RUN curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list
RUN apt update && apt install -y cloudflare-warp

RUN echo "Building for architecture: ${TARGETARCH}"

RUN curl -L https://github.com/ginuerzh/gost/releases/download/v2.12.0/gost-linux-${TARGETARCH}-2.12.0.tar.gz -o gost.tar.gz && tar -xzf /app/gost.tar.gz && chmod +x /app/gost

RUN rm /app/gost.tar.gz /app/README.md /app/README_en.md /app/LICENSE

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 1080

CMD [ "/bin/bash", "/app/start.sh" ]
