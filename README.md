# ctr-rocky8-podman
run podman inside container

## Usage

(ex) run podman container

      $ docker run -d -it --name podman --privileged --user podman tmatsuo/rocky8-podman

(ex) use podman

      $ docker exec -it rocky8-podman-dev /bin/bash
      (insdie-container)$ podman run -d --name nginx -p 8080:80 nginx
      (insdie-container)$ podman ps
      CONTAINER ID  IMAGE                           COMMAND               CREATED        STATUS            PORTS                 NAMES
      5296f9ac29b6  docker.io/library/nginx:latest  nginx -g daemon o...  4 minutes ago  Up 4 minutes ago  0.0.0.0:8080->80/tcp  nginx
      (insdie-container)$ curl localhost:8080
      <!DOCTYPE html>
      <html>
      <head>
      <title>Welcome to nginx!</title>
      ... 

