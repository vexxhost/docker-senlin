# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2024-06-25T22:49:25Z

FROM ghcr.io/vexxhost/openstack-venv-builder:zed@sha256:a0ace4ec0ba5ef4e632d534968a51b90c003ed813994906f0339a152e047c4a6 AS build
RUN --mount=type=bind,from=senlin,source=/,target=/src/senlin,readwrite <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        /src/senlin
EOF

FROM ghcr.io/vexxhost/python-base:zed@sha256:36e680558d1b807086fda4db05370d43b72716f485a3ab77d7b4a95a3809e2e1
RUN \
    groupadd -g 42424 senlin && \
    useradd -u 42424 -g 42424 -M -d /var/lib/senlin -s /usr/sbin/nologin -c "Senlin User" senlin && \
    mkdir -p /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin && \
    chown -Rv senlin:senlin /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin
COPY --from=build --link /var/lib/openstack /var/lib/openstack
