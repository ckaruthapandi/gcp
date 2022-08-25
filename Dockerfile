FROM node:latest
WORKDIR /usr/src/app 

COPY /nodewebsite/* /
RUN apt update -y
RUN npm install -y
EXPOSE 3000

CMD  [ "npm", "start" ] 
