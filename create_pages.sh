#!/bin/bash

# Your JWT token
TOKEN="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2VyZ28tdGVzdC5kZGV2LnNpdGUiLCJpYXQiOjE3NTc0ODkyMjMsIm5iZiI6MTc1NzQ4OTIyMywiZXhwIjoxNzU4MDk0MDIzLCJkYXRhIjp7InVzZXIiOnsiaWQiOiIxIn19fQ.W2-i0_uetmgsidVJUzGkxMx7J68NxGYGyc_5YgtoQCI"

# Your API endpoint
URL="https://ergo-test.ddev.site/wp-json/wp/v2/pages"

# Run 100 times
for i in {1..10}
do
  TITLE="Page $i"
  CONTENT="This is random content $RANDOM for page $i"
  EXCERPT="Excerpt $RANDOM"

  echo "Creating page $i..."

  curl --silent --location --request POST "$URL" \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/json" \
  --data "{
    \"title\": \"$TITLE\",
    \"content\": \"$CONTENT\",
    \"excerpt\": \"$EXCERPT\",
    \"status\": \"publish\"
  }"

  echo "" # new line for readability
done
