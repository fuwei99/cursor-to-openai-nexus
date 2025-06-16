FROM node:lts-alpine

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . /app

# By copying .env-example to .env, we ensure the file exists during build time.
# This can prevent "file not found" errors from application pre-flight checks.
COPY .env-example .env

RUN chmod -R 777 /app

# Create a startup script to generate .env file from environment variables
# Using a heredoc (cat <<EOF) is more robust for handling complex variables with special characters like JSON strings.
RUN echo '#!/bin/sh' > /app/docker-entrypoint.sh && \
    echo "cat <<EOF > /app/.env" >> /app/docker-entrypoint.sh && \
    echo 'PORT=${PORT:-3010}' >> /app/docker-entrypoint.sh && \
    echo 'MORGAN_FORMAT=${MORGAN_FORMAT:-tiny}' >> /app/docker-entrypoint.sh && \
    echo 'API_KEYS=${API_KEYS:-{\\"sk-123\\":[]}}' >> /app/docker-entrypoint.sh && \
    echo 'ROTATION_STRATEGY=${ROTATION_STRATEGY:-default}' >> /app/docker-entrypoint.sh && \
    echo 'USE_TLS_PROXY=${USE_TLS_PROXY:-true}' >> /app/docker-entrypoint.sh && \
    echo 'USE_OTHERS_PROXY=${USE_OTHERS_PROXY:-true}' >> /app/docker-entrypoint.sh && \
    echo 'PROXY_PLATFORM=${PROXY_PLATFORM:-auto}' >> /app/docker-entrypoint.sh && \
    echo 'USE_OTHERS=${USE_OTHERS:-true}' >> /app/docker-entrypoint.sh && \
    echo "EOF" >> /app/docker-entrypoint.sh && \
    echo 'exec "$@"' >> /app/docker-entrypoint.sh && \
    chmod +x /app/docker-entrypoint.sh

EXPOSE 3010

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["npm", "run", "start"]
