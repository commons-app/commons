#!/bin/bash
STATUS="$1"

BUILD_OUTPUT_URL=$(node ./.travis/utils/runUpload.js);
curl -H "Authorization: token ${TRAVIS_COMMENT_PERSONAL_TOKEN}" -X POST \
          -d "{\"body\": \"Get the APK for Job #$TRAVIS_JOB_NUMBER (Build #$TRAVIS_BUILD_NUMBER) at ${BUILD_OUTPUT_URL}\"}" \
          "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"