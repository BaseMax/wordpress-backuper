zip -r root.zip . -x '*.zip' '*.z0p' 'wp-content/*'

cd wp-content
zip -r wp-content.zip . -x 'uploads/*'

cd uploads
for year in 2020 2021 2022 2023 2024 2025; do
  zip -r "${year}.zip" "$year"
done

zip -r others.zip . -x "2020/*" "2021/*" "2022/*" "2023/*" "2024/*" "2025/*" "2021" "2022" "2023" "2024" "2025"
