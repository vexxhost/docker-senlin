# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2024-06-25T22:49:25Z

FROM ghcr.io/vexxhost/openstack-venv-builder:2023.1@sha256:e073941e51f17c913d074da869ea4d1ee65457e9497509011e47a0c8b69e621c AS build
RUN --mount=type=bind,from=senlin,source=/,target=/src/senlin,readwrite <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        /src/senlin
EOF

FROM ghcr.io/vexxhost/python-base:2023.1@sha256:86796ad4e5b4437a38e3adf9462ce5cb79e62c56aca18b6805522a63e44887de
RUN \
    groupadd -g 42424 senlin && \
    useradd -u 42424 -g 42424 -M -d /var/lib/senlin -s /usr/sbin/nologin -c "Senlin User" senlin && \
    mkdir -p /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin && \
    chown -Rv senlin:senlin /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin
COPY --from=build --link /var/lib/openstack /var/lib/openstack
