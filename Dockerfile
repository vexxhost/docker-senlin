# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2024-06-25T22:49:25Z

FROM ghcr.io/vexxhost/openstack-venv-builder:2023.1@sha256:9d20a7f8513102f94e354cda92ff5453c851cd19b158bfd4dab3fd11c6f31f62 AS build
RUN --mount=type=bind,from=senlin,source=/,target=/src/senlin,readwrite <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        /src/senlin
EOF

FROM ghcr.io/vexxhost/python-base:2023.1@sha256:8e195e7567febcbecf8f01a38d2df892004712caac7bbae8cf66c53d1283948e
RUN \
    groupadd -g 42424 senlin && \
    useradd -u 42424 -g 42424 -M -d /var/lib/senlin -s /usr/sbin/nologin -c "Senlin User" senlin && \
    mkdir -p /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin && \
    chown -Rv senlin:senlin /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin
COPY --from=build --link /var/lib/openstack /var/lib/openstack
