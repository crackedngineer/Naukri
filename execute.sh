cd /opt/Naukri

/usr/bin/docker compose up --build --force-recreate \
  > /tmp/naukri-output.log \
  2> /tmp/naukri-error.log

EXIT_CODE=$?

jq -n \
  --arg stdout "$(cat /tmp/naukri-output.log)" \
  --arg stderr "$(cat /tmp/naukri-error.log)" \
  --argjson exit_code "$EXIT_CODE" \
  '{
    success: ($exit_code == 0),
    exit_code: $exit_code,
    stdout: $stdout,
    stderr: $stderr
  }'

exit $EXIT_CODE