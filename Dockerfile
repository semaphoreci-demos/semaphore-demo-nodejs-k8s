FROM node:16.16.0-alpine3.15 as dist
WORKDIR /tmp/
COPY package*.json tsconfig*.json *.env ormconfig*.json ./
COPY src/ src/
RUN yarn install
RUN yarn run build

FROM node:16.16.0-alpine3.15 as node_modules
WORKDIR /tmp/
# COPY package.json package-lock.json ./
COPY package.json yarn.lock ./
RUN yarn install --production

FROM node:16.16.0-alpine3.16
WORKDIR /usr/local/nub-api
COPY --from=node_modules /tmp/node_modules ./node_modules
COPY --from=dist /tmp/dist ./dist
COPY --from=dist /tmp/*.env /tmp/ormconfig*.json ./
EXPOSE 3001
CMD ["node", "dist/main.js"]
