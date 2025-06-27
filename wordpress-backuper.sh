#!/bin/bash

ROOT="$(pwd)"

zip -r "$ROOT/root.zip" . -x '*.zip' '*.tar.gz' '*.rar' '*.sql' '*.gz' 'wp-content/*' 'wp-content'

cd "$ROOT/wp-content"
zip -r "$ROOT/wp-content.zip" . -x 'uploads/*' 'uploads'

cd "$ROOT/wp-content/uploads"

years=($(find . -maxdepth 1 -type d -regex './20[0-9][0-9]' -printf '%P\n'))
for year in "${years[@]}"; do
  zip -r "$ROOT/${year}.zip" "$year"
done

exclude_args=()
for year in "${years[@]}"; do
  exclude_args+=("-x" "${year}/*" "${year}")
done
zip -r "$ROOT/others.zip" . "${exclude_args[@]}"
