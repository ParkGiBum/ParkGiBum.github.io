#!/bin/bash

# 1. 작업할 디렉토리 설정
TARGET_DIR="$HOME/Desktop/paper/homepage/gallery"

# 해당 경로로 이동 (경로가 없으면 에러 메시지 출력 후 종료)
cd "$TARGET_DIR" || { echo "❌ 경로를 찾을 수 없습니다: $TARGET_DIR"; exit 1; }

# 2. 결과물을 저장할 새 폴더 생성 (원본 보존용)
OUTPUT_DIR="output"
mkdir -p "$OUTPUT_DIR"

COUNTER=1

echo "🔄 이미지 변환 및 이름 변경 작업을 시작합니다..."

# 3. 대소문자 구분 없이 heic, jpg, jpeg 파일 모두 찾기
shopt -s nullglob nocaseglob
for file in *.{heic,jpg,jpeg}; do
    
    # 저장될 새 파일 경로와 이름 (예: output/Photo 1.jpg)
    NEW_NAME="${OUTPUT_DIR}/photo${COUNTER}.jpg"

    # 확장자를 소문자로 추출하여 확인
    EXTENSION="${file##*.}"
    EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')

    if [ "$EXTENSION" = "heic" ]; then
        # HEIC 파일인 경우: macOS 내장 sips 명령어로 JPG 변환
        echo "📸 변환 중: '$file' -> 'photo${COUNTER}.jpg'"
        sips -s format jpeg "$file" --out "$NEW_NAME" > /dev/null 2>&1
    else
        # 이미 JPG/JPEG 파일인 경우: 포맷 변환 없이 복사만 진행
        echo "📝 복사 중: '$file' -> 'photo${COUNTER}.jpg'"
        cp "$file" "$NEW_NAME"
    fi

    ((COUNTER++))
done

# 설정 되돌리기
shopt -u nullglob nocaseglob

echo "✅ 모든 작업이 완료되었습니다! 변환된 파일은 $TARGET_DIR/$OUTPUT_DIR 폴더를 확인해 주세요."