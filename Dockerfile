FROM node:lts-alpine

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . /app

RUN chmod -R 777 /app

# Create a startup script to generate .env file from environment variables
RUN echo '#!/bin/sh' > /app/docker-entrypoint.sh && \
    echo 'echo "# Generated .env file from environment variables" > /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'echo "PORT=${PORT:-3010}" >> /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'echo "MORGAN_FORMAT=${MORGAN_FORMAT:-tiny}" >> /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'echo "API_KEYS=${API_KEYS:-{\\"sk-123\\":[]}}" >> /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'echo "ROTATION_STRATEGY=${ROTATION_STRATEGY:-default}" >> /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'echo "USE_TLS_PROXY=${USE_TLS_PROXY:-true}" >> /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'echo "USE_OTHERS_PROXY=${USE_OTHERS_PROXY:-true}" >> /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'echo "PROXY_PLATFORM=${PROXY_PLATFORM:-auto}" >> /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'echo "USE_OTHERS=${USE_OTHERS:-true}" >> /app/.env' >> /app/docker-entrypoint.sh && \
    echo 'exec "$@"' >> /app/docker-entrypoint.sh && \
    chmod +x /app/docker-entrypoint.sh

EXPOSE 3010

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["npm", "run", "start"]
