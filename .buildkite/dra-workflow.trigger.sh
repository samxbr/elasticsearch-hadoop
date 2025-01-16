#!/bin/bash

set -euo pipefail

echo "steps:"

source .buildkite/branches.sh

for BRANCH in "${BRANCHES[@]}"; do
  cat <<EOF
  - trigger: elasticsearch-hadoop-dra-workflow
    label: Trigger DRA snapshot workflow for $BRANCH
    async: true
    build:
      branch: "$BRANCH"
      env:
        DRA_WORKFLOW: snapshot
EOF
	if [[ "$BRANCH" != "main" ]]; then
		cat <<EOF
  - trigger: elasticsearch-hadoop-dra-workflow
    label: Trigger DRA staging workflow for $BRANCH
    async: true
    build:
      branch: "$BRANCH"
      env:
        DRA_WORKFLOW: staging
EOF
	else
		# Pass version qualifier to main builds
		cat <<EOF
  - trigger: elasticsearch-hadoop-dra-workflow
    label: Trigger DRA staging workflow for $BRANCH
    async: true
    build:
      branch: "$BRANCH"
      env:
        DRA_WORKFLOW: staging
        VERSION_QUALIFIER: alpha1
EOF
	fi
done
