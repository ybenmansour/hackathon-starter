# Base stage
# ---------------------------------------
FROM node:lts-alpine3.16 AS base

# This get shared across later stages
WORKDIR /usr/src/app


# Source stage
# ---------------------------------------
FROM base AS source

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

COPY package*.json ./

RUN npm ci && npm cache clean --force --only=production

COPY . .


# Test stage
# ---------------------------------------
FROM source AS test

ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

RUN npm run test && npm run lint

# Production stage
# ---------------------------------------
FROM source AS production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
ENV PATH /node/node_modules/.bin:$PATH
ENV SERVER_PORT=3000

EXPOSE $SERVER_PORT

CMD [ "node", "app.js" ]
EXPOSE 3000
