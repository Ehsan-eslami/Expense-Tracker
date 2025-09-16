# Docker file for the expense tracker application
FROM node:20-alpine

# create a non-root user to run the application
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=/home/node/.npm-global/bin:$PATH

# create a directory for npm global packages and set permissions
RUN mkdir -p /home/node/.npm-global && chown -R node:node /home/node

# switch to non-root user
USER node

# install npm package globally
RUN npm install -g

# set working directory
WORKDIR /app

# copy package files
COPY package*.json ./

# install dependencies
RUN npm ci

# copy Prisma schema for generation
COPY prisma ./prisma

# generate Prisma client
RUN npx prisma generate

# copy source code
COPY . .

# build the application
RUN npm run build

# expose port
EXPOSE 3000

# start the application
CMD ["npm", "start"]

