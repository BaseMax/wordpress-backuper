#!/bin/bash

set -euo pipefail

# === Config ===
ROOT="$(pwd)"
WP_CONTENT_DIR="$ROOT/wp-content"
UPLOADS_DIR="$WP_CONTENT_DIR/uploads"
LOG_FILE="$ROOT/zip_process.log"
ZIP_OPTIONS="-r"

EXCLUDE_PATTERNS=('*.zip' '*.tar.gz' '*.rar' '*.sql' '*.gz' "${WP_CONTENT_DIR}/*" "${WP_CONTENT_DIR}")

command -v zip >/dev/null 2>&1 || { echo "❌ zip command not found. Please install zip."; exit 1; }
command -v find >/dev/null 2>&1 || { echo "❌ find command not found. Please install find."; exit 1; }

echo "📁 Working directory: $ROOT"
echo "Logging output to: $LOG_FILE"
echo "-------------------------------" | tee "$LOG_FILE"

function zip_folder() {
  local zip_name="$1"
  local target="$2"
  echo "📝 Creating $zip_name.zip for $target..." | tee -a "$LOG_FILE"
  zip $ZIP_OPTIONS "$ROOT/${zip_name}.zip" "$target" >> "$LOG_FILE" 2>&1
}

echo "🔄 Creating root.zip..." | tee -a "$LOG_FILE"
zip $ZIP_OPTIONS "$ROOT/root.zip" . $(printf -- '-x %s ' "${EXCLUDE_PATTERNS[@]}") >> "$LOG_FILE" 2>&1

if [ -d "$WP_CONTENT_DIR" ]; then
  echo "🔄 Creating wp-content.zip..." | tee -a "$LOG_FILE"
  pushd "$WP_CONTENT_DIR" > /dev/null
  zip $ZIP_OPTIONS "$ROOT/wp-content.zip" . -x 'uploads/*' 'uploads' >> "$LOG_FILE" 2>&1
  popd > /dev/null
else
  echo "⚠️  wp-content directory not found, skipping wp-content.zip" | tee -a "$LOG_FILE"
fi

if [ -d "$UPLOADS_DIR" ]; then
  echo "📂 Processing uploads directory..." | tee -a "$LOG_FILE"
  pushd "$UPLOADS_DIR" > /dev/null
  
  years=()
  while IFS= read -r -d $'\0' dir; do
    dir=${dir#./}
    years+=("$dir")
  done < <(find . -maxdepth 1 -type d -regex './20[0-9][0-9]' -print0)
  
  if [ ${#years[@]} -eq 0 ]; then
    echo "⚠️  No year directories found in uploads" | tee -a "$LOG_FILE"
  else
    echo "🗂 Found year directories: ${years[*]}" | tee -a "$LOG_FILE"
    
    for year in "${years[@]}"; do
      zip_folder "$year" "$year"
    done
  fi
  
  exclude_args=()
  for year in "${years[@]}"; do
    exclude_args+=("-x" "${year}/*" "${year}")
  done
  
  echo "📦 Creating others.zip excluding year directories..." | tee -a "$LOG_FILE"
  zip $ZIP_OPTIONS "$ROOT/others.zip" . "${exclude_args[@]}" >> "$LOG_FILE" 2>&1

  popd > /dev/null
else
  echo "❌ uploads directory not found: $UPLOADS_DIR" | tee -a "$LOG_FILE"
  exit 1
fi

echo "✅ All zip files created successfully in: $ROOT" | tee -a "$LOG_FILE"
