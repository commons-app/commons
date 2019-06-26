#!/bin/bash
STATUS="$1"

TIMESTAMP=$(date -u +%FT%TZ)

if [ "$STATUS" = "success" ]; then
    EMBED_COLOR=3066993
    STATUS_MESSAGE="Passed"
elif [ "$STATUS" = "failure" ]; then
    EMBED_COLOR=15158332
    STATUS_MESSAGE="Failed"
fi

WEBHOOK_DATA='{
  "username": "ApolloTV (Travis)",
  "content": "@BuildNotify A new build has completed",
  "embeds": [ {
    "color": '$EMBED_COLOR',
    "author": {
      "name": "Job #'"$TRAVIS_JOB_NUMBER"' (Build #'"$TRAVIS_BUILD_NUMBER"') '"$STATUS_MESSAGE"' - '"$TRAVIS_REPO_SLUG"'",
      "url": "'"$TRAVIS_BUILD_WEB_URL"'"
    },
    "title": "'"$COMMIT_SUBJECT"'",
    "url": "'"$URL"'",
    "description": "**Build Information**: '"${COMMIT_MESSAGE//$'\n'/ }"\\n\\n"$CREDITS"'",
    "fields": [
      {
        "name": "Commit",
        "value": "'"[${TRAVIS_COMMIT:0:7}](https://github.com/$TRAVIS_REPO_SLUG/commit/$TRAVIS_COMMIT)"'",
        "inline": true
      },
      {
        "name": "Branch",
        "value": "'"[$TRAVIS_BRANCH](https://github.com/$TRAVIS_REPO_SLUG/tree/$TRAVIS_BRANCH)"'",
        "inline": true
      },
      {
        "name": "Files",
        "value": "'"[Download APK]($BUILD_OUTPUT_URL)"'"
      }
    ],
    "timestamp": "'"$TIMESTAMP"'"
  } ]
}'

(curl --fail --progress-bar -H Content-Type:application/json -d "$WEBHOOK_DATA" "$2" \
&& echo -e "\\n[Webhook]: Successfully sent the webhook.") || echo -e "\\n[Webhook]: Unable to send webhook."