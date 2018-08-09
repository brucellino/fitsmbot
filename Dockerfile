FROM quay.io/nordstrom/hubot
ADD . /app
WORKDIR /app
CMD [ "bin/hubot", "-a", "slack" ]
