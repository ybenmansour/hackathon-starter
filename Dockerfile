FROM node:lts-alpine3.16 AS base
WORKDIR /usr/src/app
COPY package*.json ./

FROM base AS test
RUN npm ci
COPY . .
RUN ["npm", "test"]


FROM base as sonarscanner
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
RUN npm i -D sonarqube-scanner -save-dev
RUN apk add openjdk8-jre
RUN java -version
RUN echo $JAVA_HOME
COPY . .
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && apk --allow-untrusted --force add glibc-2.23-r3.apk
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
