FROM node:18.20.4-alpine AS dependencies
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

FROM node:18.20.4-alpine AS runner
ENV NODE_ENV=production \
    PORT=8000 \
    DATABASE_NAME=/app/data/dev.sqlite
WORKDIR /app
RUN addgroup -S nodeapp && adduser -S nodeapp -G nodeapp && mkdir -p /app/data && chown -R nodeapp:nodeapp /app
COPY --from=dependencies /app/node_modules ./node_modules
COPY --chown=nodeapp:nodeapp . .
USER nodeapp
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 CMD wget -qO- http://127.0.0.1:8000/health || exit 1
CMD ["node", "index.js"]
