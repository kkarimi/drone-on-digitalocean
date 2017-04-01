#!/bin/bash

DRONE_IO_VERSION="0.5"

mkdir /etc/drone
touch /etc/drone/docker-compose.yml
echo Download and Install Docker-Compose
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

echo Writing docker-compose file
cat > /etc/drone/docker-compose.yml << EOF
version: '2'

services:
  drone-server:
    image: drone/drone:$DRONE_IO_VERSION
    ports:
      - 80:8000
    volumes:
      - ./drone:/var/lib/drone/
    restart: always
    environment:
      - DRONE_OPEN=true
      - DRONE_GITHUB=true
      - DRONE_GITHUB_CLIENT=${DRONE_GITHUB_CLIENT}
      - DRONE_GITHUB_SECRET=${DRONE_GITHUB_SECRET}
      - DRONE_SECRET=${DRONE_SECRET}

  drone-agent:
    image: drone/drone:$DRONE_IO_VERSION
    command: agent
    restart: always
    depends_on: [ drone-server ]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - DRONE_SERVER=ws://drone-server:8000/ws/broker
      - DRONE_SECRET=${DRONE_SECRET}
EOF

echo Running Drone IO..
docker-compose -f /etc/drone/docker-compose.yml up -d
