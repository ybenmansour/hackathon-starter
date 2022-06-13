FROM node:lts-alpine3.16 AS base
WORKDIR /usr/src/app
COPY package*.json ./

FROM base AS test
RUN npm ci
COPY . .
RUN ["npm", "test"]


FROM base as sonarscanner
RUN npm i -D sonarqube-scanner -save-dev
RUN apk add openjdk8-jre && java -version
COPY . .
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /root/.sonar/native-sonar-scanner/sonar-scanner-4.5.0.2216-linux/bin/sonar-scanner
RUN npm run sonar


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
