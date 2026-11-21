FROM eclipse-temurin:21-jre

WORKDIR /server
RUN apt-get update && apt-get install -y --no-install-recommends curl python3     && rm -rf /var/lib/apt/lists/*

COPY . .
RUN chmod +x ./start.sh

EXPOSE 25565/tcp
EXPOSE 19132/udp

CMD ["./start.sh"]
