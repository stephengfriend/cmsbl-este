FROM 294321010831.dkr.ecr.us-east-1.amazonaws.com/cmsbl/base:5.5.0

MAINTAINER Stephen G. Friend, hello@stephengfriend.com

ENV DIR=/opt/este NODE_ENV=production PORT=80

COPY package.json ${DIR}/

RUN apk add --update python python-dev build-base && \
  cd ${DIR} && echo "# REPLACE ME" > README.md && \
  npm install --production --no-progress && \
  apk del python python-dev build-base ${DEL_PKGS} && \
  rm -rf /etc/ssl /usr/share/man /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html

COPY scripts src/browser src/common src/server test/ webpack/ .babelrc .dockerignore .editorconfig .eslintignore .eslintrc .node-version app.json Dockerrun.aws.json.template gulpfile.babel.js LICENSE README.md ${DIR}/

WORKDIR ${DIR}

RUN gulp build -p

EXPOSE ${PORT}

ENTRYPOINT ["npm"]

CMD ["start"]
