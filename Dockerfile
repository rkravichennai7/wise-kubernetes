FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install deps
# - cowsay + fortune binaries live in /usr/games
# - fortunes package provides the quote databases (avoids "No fortunes found")
# - netcat-openbsd supports -N for clean close
RUN apt-get update && apt-get install -y --no-install-recommends \
    cowsay fortune-mod fortunes netcat-openbsd ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Ensure cowsay/fortune are on PATH
ENV PATH="/usr/games:${PATH}"

WORKDIR /app
COPY wisecow.sh /app/wisecow.sh
RUN chmod +x /app/wisecow.sh

# Run as non-root
RUN useradd -u 10001 -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 4499
ENTRYPOINT ["/app/wisecow.sh"]
