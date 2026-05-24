env_args=()
for var in http_proxy https_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY no_proxy; do
  if [[ -n "${!var:-}" ]]; then
    env_args+=("$var='${!var}'")
  fi
done

if [[ ${#env_args[@]} -gt 0 ]]; then
  exec sudo "${env_args[@]}" "$@"
else
  exec sudo "$@"
fi
