FROM node:5

MAINTAINER Stephen G. Friend, hello@stephengfriend.com

ENV DIR=/opt/este NODE_ENV=production

RUN npm install -g gulp-cli --silent

# Install dependencies
COPY package.json ${DIR}/
RUN cd ${DIR} && echo "# REPLACE ME" > README.md && npm install --silent

# Bundle app source
COPY . ${DIR}

# NPM commands must be run from the node project root
WORKDIR ${DIR}

# Make `npm` the default executable
ENTRYPOINT ["npm"]

# Start server
CMD ["start"]
