# SPDX-FileCopyrightText: © 2025 VEXXHOST, Inc.
# SPDX-License-Identifier: GPL-3.0-or-later
# Atmosphere-Rebuild-Time: 2024-06-25T22:49:25Z

FROM ghcr.io/vexxhost/openstack-venv-builder:zed@sha256:b9952efb794dda2218e22680a85e3dfdca210fb867317fecf4c2c85c25cee5e1 AS build
RUN --mount=type=bind,from=senlin,source=/,target=/src/senlin,readwrite <<EOF bash -xe
uv pip install \
    --constraint /upper-constraints.txt \
        /src/senlin
EOF

FROM ghcr.io/vexxhost/python-base:zed@sha256:954839925fc42a0b75e161da126bedd5384a832fbeae8ff49c3a3be3ae12bf8e
RUN \
    groupadd -g 42424 senlin && \
    useradd -u 42424 -g 42424 -M -d /var/lib/senlin -s /usr/sbin/nologin -c "Senlin User" senlin && \
    mkdir -p /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin && \
    chown -Rv senlin:senlin /etc/senlin /var/log/senlin /var/lib/senlin /var/cache/senlin
COPY --from=build --link /var/lib/openstack /var/lib/openstack
