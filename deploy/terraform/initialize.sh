#!/bin/bash

# Exit upon encountering an error
set -euo pipefail

terraform init -backend-config="bucket=torrent-scraper-tf-state-remote"
