# Use Node.js LTS
FROM node:18

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --production

COPY . .

EXPOSE 3002
CMD ["npm", "start"]
