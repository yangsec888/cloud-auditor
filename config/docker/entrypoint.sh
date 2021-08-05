#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /cloud-auditor/tmp/pids/server.pid
# Prepare DB (Migrate - If not? Create db & Migrate)
sh ./config/docker/prepare-db.sh

# Pre-comple app assets
sh ./config/docker/asset-pre-compile.sh

# start rails app
# sh ./config/docker/start.sh

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
