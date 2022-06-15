FROM node:lts-slim AS base
WORKDIR /usr/src/app
COPY package*.json ./

FROM base AS test
RUN npm ci
COPY . .
RUN ["npm", "test"]


FROM base as sonarscanner
RUN npm ci
RUN npm install --save-dev sonarqube-scanner
COPY . .
CMD ["npm","run", "sonar"]


FROM base AS production
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
ENV PATH /node/node_modules/.bin:$PATH
ENV SERVER_PORT=8080


RUN npm install pm2 -g
RUN npm install --production
COPY . .
CMD ["pm2-runtime","app.js"]
EXPOSE 8080
