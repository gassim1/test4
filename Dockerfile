# ---- build stage ----
FROM node:20-bookworm-slim AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build --if-present
RUN npm prune --omit=dev

# ---- runtime stage ----
FROM node:20-bookworm-slim
ENV NODE_ENV=production
# Tesseract is needed for OCR (English, Arabic, Spanish, French)
RUN apt-get update && apt-get install -y --no-install-recommends \
      tesseract-ocr tesseract-ocr-eng tesseract-ocr-ara tesseract-ocr-spa tesseract-ocr-fra \
      tini ca-certificates \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=build --chown=node:node /app /app
RUN mkdir -p /data && chown node:node /data
USER node
EXPOSE 3000
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["npm", "start"]
