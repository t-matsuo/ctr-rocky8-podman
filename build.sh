#!/bin/bash
set -e

sed 's|^RUN|RUN --mount=type=cache,id=rocky8,target=/var/cache/dnf --mount=type=cache,id=rocky8,target=/var/lib/dnf|g' Dockerfile > _Dockerfile.tmp
echo "docker build -t tmatsuo/rocky8-podman -f _Dockerfile.tmp ."
DOCKER_BUILDKIT=1 docker build --progress=plain -t tmatsuo/rocky8-podman -f _Dockerfile.tmp .
