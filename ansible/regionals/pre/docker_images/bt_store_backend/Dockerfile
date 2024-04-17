FROM node:20.11.1-alpine

WORKDIR /home/node

COPY package*.json .

RUN npm install

COPY index.js .

USER node

CMD [ "/home/node/index.js" ]
