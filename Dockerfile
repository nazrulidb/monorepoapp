# --- Stage 1: Build ---
# Using Node 16 (Perfect for older 7-9 year old projects)
FROM node:16-alpine AS builder

WORKDIR /app

# 1. Copy root config and dependency files
COPY package.json yarn.lock babel.config.js ./

# 2. Copy the folders
COPY shared/ ./shared/
COPY web/ ./web/
COPY server/ ./server/

# 3. Install dependencies
RUN yarn install --frozen-lockfile

# 4. Build the frontend
WORKDIR /app/web
# DELETE THE ENV NODE_OPTIONS LINE - It is not needed in Node 16
RUN yarn build

# --- Stage 2: Production ---
# --- Stage 2: Production ---
FROM node:16-alpine
WORKDIR /app

# 1. Copy everything from builder
COPY --from=builder /app ./

# 2. Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

# 3. Use the local babel-node binary to start the app
# This allows Node to read the 'import' statements in start-prod.js
CMD ["./node_modules/.bin/babel-node", "server/start-prod.js"]
