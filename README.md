# testing-server

A configurable Paper Minecraft server template. GitHub stores these files; a separate Linux host or game-server panel must run the server process.

## Requirements
- Java 21 for Minecraft 1.21.8
- Linux host with outbound HTTPS access
- At least 2 GB RAM for a small test server (more may be needed with plugins or players)

## Configure
1. Edit `MC_VERSION` in `start.sh` if you want a different Paper-supported Minecraft version.
2. Review `server.properties`. The default keeps the server in online mode and enables the whitelist.
3. Upload approved plugin JARs into `plugins/` using your hosting panel or SFTP.
4. Start the server once. It will download the matching Paper build.
5. Read the Minecraft EULA at https://www.minecraft.net/eula. If you agree, change `eula=false` to `eula=true` in `eula.txt`, then restart.

## Start on Linux
```bash
chmod +x start.sh
./start.sh
```

The script downloads Paper from the official Paper downloads API when `paper.jar` is absent, then launches it with a 2G minimum and 4G maximum heap. Adjust `JAVA`, `XMS`, and `XMX` environment variables to suit your host.

## Docker
Build and run with Docker Compose:
```bash
docker compose up -d
docker compose logs -f
```
The container uses Java 21 and persists the server directory. You must still accept the EULA yourself in `eula.txt` before the server will start successfully.

## Connect
Use your hosting provider's public address and configured Java port (default `25565`). Do not commit world data, server secrets, or private keys to GitHub.

## Crossplay
For Bedrock access, install compatible Geyser and Floodgate builds in `plugins/` and configure their ports in the host panel/firewall. The default Java port is 25565; the common Bedrock UDP port is 19132, but your host may assign different ports.
