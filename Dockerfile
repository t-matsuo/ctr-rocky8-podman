FROM rockylinux/rockylinux:8.5
LABEL maintainer="matsuo.tak@gmail.com"

RUN echo "keepcache=True" >> /etc/dnf/dnf.conf
RUN dnf install -y podman podman-plugins crun
RUN rpm -Fvh https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-arptables-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-debuginfo-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-debugsource-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-devel-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-ebtables-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-libs-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-libs-debuginfo-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-services-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-utils-1.8.4-20_include_legacy.el8.x86_64.rpm \
             https://github.com/t-matsuo/ctr-rocky8-podman/raw/main/iptables-legacy/iptables-utils-debuginfo-1.8.4-20_include_legacy.el8.x86_64.rpm \

RUN ln -nfs xtables-legacy-multi /usr/sbin/iptables; ln -nfs xtables-legacy-multi /usr/sbin/iptables-save; echo "exclude=iptables*" >> /etc/yum.conf

COPY ./containers.conf /etc/containers/containers.conf
RUN chmod 644 /etc/containers/containers.conf; \
    sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' \
           -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' /etc/containers/storage.conf

RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; \
    touch /var/lib/shared/overlay-images/images.lock; \
    touch /var/lib/shared/overlay-layers/layers.lock; \
    touch /var/lib/shared/vfs-images/images.lock; \
    touch /var/lib/shared/vfs-layers/layers.lock

RUN useradd podman; \
    echo podman:10000:65536 > /etc/subuid; \
    echo podman:10000:65536 > /etc/subgid; \
    mkdir -p /home/podman/.local/share/containers; \
    mkdir -p /home/podman/.config/cni && \
    chmod 4755 /usr/bin/newuidmap && \
    chmod 4755 /usr/bin/newgidmap

COPY podman-containers.conf /home/podman/.config/containers/containers.conf
RUN  chown podman:podman -R /home/podman

ENV _CONTAINERS_USERNS_CONFIGURED=""
