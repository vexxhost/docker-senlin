# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2024-06-25T22:49:25Z

FROM ghcr.io/vexxhost/openstack-venv-builder:2023.1@sha256:a991466691718ef3d9557da23c2e0f6a14e956fa21e5e99fbc6fb011872853d5 AS build
RUN --mount=type=bind,from=senlin,source=/,target=/src/senlin,readwrite <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        /src/senlin
EOF

FROM ghcr.io/vexxhost/python-base:2023.1@sha256:d2702936a9577055998a971b9e2ee46170e0c39bc0713f89b0c589187802c4d5
RUN \
    groupadd -g 42424 senlin && \
    useradd -u 42424 -g 42424 -M -d /var/lib/senlin -s /usr/sbin/nologin -c "Senlin User" senlin && \
    mkdir -p /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin && \
    chown -Rv senlin:senlin /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin
COPY --from=build --link /var/lib/openstack /var/lib/openstack
