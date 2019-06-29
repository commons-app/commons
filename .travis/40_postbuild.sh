#!/bin/bash
STATUS="$1"

TIMESTAMP=$(date -u +%FT%TZ)

if [ "$STATUS" = "success" ]; then
    curl -H "Authorization: token ${TRAVIS_COMMENT_PERSONAL_TOKEN}" -X POST \
-d "{\"body\": \"Get the APK for Job #'"$TRAVIS_JOB_NUMBER"' (Build #'"$TRAVIS_BUILD_NUMBER"') at $TRAVIS_BUILD_WEB_URL\"}" \
"https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"
fi