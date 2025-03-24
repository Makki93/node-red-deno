@ -0,0 +1,54 @@
FROM alpine:3.19

# Arbeitsverzeichnis festlegen
WORKDIR /app

# Grundlegende Pakete installieren
RUN apk add --no-cache \
  bash \
  curl \
  unzip \
  git \
  nodejs \
  npm

# Deno 2.0 installieren
RUN curl -fsSL https://deno.land/install.sh | sh
ENV DENO_INSTALL="/root/.deno"
ENV PATH="${DENO_INSTALL}/bin:${PATH}"
# Verify deno is in PATH
RUN echo $PATH && ls -la /root/.deno/bin

# Prüfe, ob Deno installiert ist und upgrade auf canary
RUN /root/.deno/bin/deno --version && \
  /root/.deno/bin/deno upgrade canary

# Deno 2.0 hat Node.js-Kompatibilitätsmodus
# Backup der Node.js-Binaries erstellen
RUN cp $(which node) /usr/bin/node.orig && \
  cp $(which npm) /usr/bin/npm.orig

# Wrapper für node und npm erstellen
RUN echo '#!/bin/sh\n\
  if [ "$1" = "--version" ]; then\n\
  /usr/bin/node.orig --version\n\
  else\n\
  /root/.deno/bin/deno node "$@"\n\
  fi' > /usr/bin/node && \
  chmod +x /usr/bin/node && \
  echo '#!/bin/sh\n\
  if [ "$1" = "--version" ]; then\n\
  /usr/bin/npm.orig --version\n\
  else\n\
  /root/.deno/bin/deno npm "$@"\n\
  fi' > /usr/bin/npm && \
  chmod +x /usr/bin/npm

# Node-RED installieren
RUN npm install -g --unsafe-perm node-red

# Port freigeben
EXPOSE 1880

# Startbefehl mit Fallback auf Node.js original wenn Deno fehlschlägt
CMD ["sh", "-c", "echo 'Starte Node-RED mit Deno...' && node-red || echo 'Fallback auf Node.js...' && /usr/bin/node.orig /usr/local/bin/node-red"]