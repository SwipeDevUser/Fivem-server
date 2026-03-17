FROM node:18-alpine
WORKDIR /usr/src/app

# Install dependencies
COPY package.json package-lock.json* ./
RUN npm install --production || true

# Copy app
COPY . .

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=3s CMD wget -q -O- http://localhost:3000/health || exit 1

CMD ["node", "src/index.js"]
