#!/bin/bash
TIMESTAMP=$(date -u +%FT%TZ)

AUTHOR_NAME="$(git log -1 "$TRAVIS_COMMIT" --pretty="%aN")"
COMMITTER_NAME="$(git log -1 "$TRAVIS_COMMIT" --pretty="%cN")"
COMMIT_SUBJECT="$(git log -1 "$TRAVIS_COMMIT" --pretty="%s")"
COMMIT_MESSAGE="$(git log -1 "$TRAVIS_COMMIT" --pretty="%b")"

WEBHOOK_DATA='{
    "username": "ApolloTV (Travis)",
    "content": "A build has started.\n\n[Job #'"$TRAVIS_JOB_NUMBER"' (Build #'"$TRAVIS_BUILD_NUMBER"') '"$STATUS_MESSAGE"' ('"$AUTHOR_NAME"') - '"$TRAVIS_REPO_SLUG"'\n\n'"$COMMIT_SUBJECT"']('"$TRAVIS_BUILD_WEB_URL"')"
}'

(curl --fail --progress-bar -H Content-Type:application/json -d "$WEBHOOK_DATA" "$1" \
&& echo -e "\\n[Webhook]: Successfully sent the webhook.") || echo -e "\\n[Webhook]: Unable to send webhook."