FROM node:18.20.4-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm install

FROM node:18.20.4-alpine AS runner
ENV NODE_ENV=production \
    PORT=8000 \
    DATABASE_NAME=/app/data/dev.sqlite
WORKDIR /app
RUN addgroup -g 10001 -S nodeapp && adduser -u 10001 -S nodeapp -G nodeapp && mkdir -p /app/data && chown -R 10001:10001 /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY --chown=nodeapp:nodeapp . .
USER 10001
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 CMD wget -qO- http://127.0.0.1:8000/health || exit 1
CMD ["node", "index.js"]
