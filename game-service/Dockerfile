FROM node:18

# Set work directory
WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
RUN npm install --production

# Copy application files
COPY . .

# Set production environment
ENV NODE_ENV=production

# Expose correct port
EXPOSE 3001

# Start application
CMD ["node", "index.js"]
