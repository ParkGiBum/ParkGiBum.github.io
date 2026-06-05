#!/bin/bash

TARGET_DIR="$HOME/Desktop/paper/homepage/gallery"
cd "$TARGET_DIR" || { echo "경로를 찾을 수 없습니다: $TARGET_DIR"; exit 1; }

OUTPUT_DIR="output"
rm -f "$OUTPUT_DIR"/*.jpg "$OUTPUT_DIR"/*.jpeg "$OUTPUT_DIR"/*.png 2>/dev/null
mkdir -p "$OUTPUT_DIR"

echo "날짜순 정렬 후 이미지 변환 및 썸네일 생성을 시작합니다..."

# 파일별 날짜를 수집해 임시 파일에 저장
TMPFILE=$(mktemp)

shopt -s nullglob nocaseglob
for file in *.{heic,jpg,jpeg,png}; do
    DATE=$(mdls -name kMDItemContentCreationDate "$file" 2>/dev/null \
        | awk '{print $3, $4}' | head -1)
    if [ -z "$DATE" ] || [ "$DATE" = "null" ]; then
        DATE=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$file")
    fi
    echo "$DATE	$file" >> "$TMPFILE"
done
shopt -u nullglob nocaseglob

COUNTER=1
# 날짜 내림차순 정렬 (최신이 먼저)
while IFS='	' read -r DATE FILE; do
    LARGE_NAME="${OUTPUT_DIR}/Photo ${COUNTER}.jpg"
    THUMB_NAME="${OUTPUT_DIR}/thumb_Photo ${COUNTER}.jpg"

    echo "[$COUNTER] '$FILE' ($DATE)"

    sips -s format jpeg -s formatOptions 80 -Z 1920 "$FILE" --out "$LARGE_NAME" > /dev/null 2>&1
    sips -s format jpeg -s formatOptions 70 -Z 400  "$FILE" --out "$THUMB_NAME" > /dev/null 2>&1

    ((COUNTER++))
done < <(sort -r "$TMPFILE")

rm -f "$TMPFILE"
echo "완료! 총 $((COUNTER-1))장 생성됐습니다."
