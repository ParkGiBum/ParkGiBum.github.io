#!/bin/bash

TARGET_DIR="$HOME/Desktop/paper/homepage/gallery"
cd "$TARGET_DIR" || { echo "❌ 경로를 찾을 수 없습니다: $TARGET_DIR"; exit 1; }

OUTPUT_DIR="output"
mkdir -p "$OUTPUT_DIR"

COUNTER=1
echo "🔄 이미지 변환 및 썸네일 생성을 시작합니다..."

shopt -s nullglob nocaseglob
for file in *.{heic,jpg,jpeg,png}; do
    
    LARGE_NAME="${OUTPUT_DIR}/Photo ${COUNTER}.jpg"
    THUMB_NAME="${OUTPUT_DIR}/thumb_Photo ${COUNTER}.jpg"

    echo "📸 처리 중: [$COUNTER] '$file'"
    
    # 1. 고화질 버전 (라이트박스 확대용, 최대 1920px)
    sips -s format jpeg -s formatOptions 80 -Z 1920 "$file" --out "$LARGE_NAME" > /dev/null 2>&1
    
    # 2. 썸네일 버전 (갤러리 화면용, 최대 400px, 용량 대폭 감소)
    sips -s format jpeg -s formatOptions 70 -Z 400 "$file" --out "$THUMB_NAME" > /dev/null 2>&1

    ((COUNTER++))
done
shopt -u nullglob nocaseglob

echo "✅ 완료! output 폴더에 원본과 썸네일(thumb_)이 모두 생성되었습니다."