SCR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONSTER="$SCR/MonsterROM-SM7150"
CREDIT="Signed-off-by: Mehedi H Joy 
<mh506370@gmail.com>"

git config --global user.name "Mehedi H Joy"
git config --global user.email "mh506370@gmail.com"
git config --global url."https://${GH_TOKEN}@github.com/".insteadOf "https://github.com/"

cd $SCR
git clone https://oauth2:${GH_TOKEN}@github.com/mehedihjoy0/MonsterROM-SM7150.git $MONSTER

cd $MONSTER
git remote add upstream https://github.com/devcore94/MonsterROM
git checkout sixteenQPR2
git fetch upstream
git reset --hard upstream/sixteenQPR2
git clean -fd
#git push origin sixteenQPR2 --force

sed -i "/pull_request:/,/cancel-in-progress: true/d" .github/workflows/build.yml
sed -i "/schedule:/,/cancel-in-progress: true/d" .github/workflows/blobs.yml
git add .
git commit -m ".github/workflows: remove automatic workflow & concurrency run" -m "$CREDIT"
git push origin sixteenQPR2 --force

sed -i '/# Show battery regulatory info in Settings/,/SET_FLOATING_FEATURE_CONFIG "SEC_FLOATING_FEATURE_SETTINGS_ENABLE_EU_BATTERY_REGULATORY" "TRUE"/d' unica/mods/tweaks/customize.sh
rsync -av --inplace --no-compress $SCR/unica/mods/bsoh unica/mods
git add .
git commit -m "unica/mods/bsoh: init" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/unica/mods/applock unica/mods
git add .
git commit -m "unica/mods/applock: init" -m "$CREDIT"
#git push origin sixteenQPR2

touch unica/mods/preload/disable
git add .
git commit -m "unica/mods/preload: disable" -m "$CREDIT"
#git push origin sixteenQPR2

cat << 'EOF' >> unica/mods/prophide/system/bin/prophide.sh
rezetprop -n ro.crypto.state "encrypted"
EOF
git add .
git commit -m "unica/mods/prophide: add 'ro.crypto.state' prop" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/unica/mods/saf unica/mods
git add .
git commit -m "unica/mods/saf: init" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/unica/mods/v4a unica/mods
git add .
git commit -m "unica/mods/v4a: init" -m "$CREDIT"
#git push origin sixteenQPR2

sed -i '/Downloading latest Samsung Wallpaper/,+2d' unica/mods/wallpaper/customize.sh
mv unica/mods/wallpaper unica/mods/~wallpaper
git add .
git commit -m "unica/mods/wallpaper: run this mod at last" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/unica/mods/watermark unica/mods
git add .
git commit -m "unica/mods/watermark: init" -m "$CREDIT"
#git push origin sixteenQPR2

sed -i '/# Samsung Messages/,/^"/c\# Google Messages\nPRODUCT_DEBLOAT+="\npriv-app/Messages\n"' unica/debloat.sh
git add .
git commit -m "unica: debloat 'Google Messages' instead of 'Samsung Messages'" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/prebuilts/samsung/r9qxxx prebuilts/samsung
git add .
git commit -m "prebuilts/samsung/r9qxxx: add 'display' stack" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/prebuilts/samsung/e1qzcx prebuilts/samsung
sed -i '/- module: "Galaxy A73 5G (a73xqxx)"/i \          - module: "Galaxy S24 (e1qzcx)"\n            device: "e1qzcx"\n            firmware: "SM-S9210/CHC/356724910402671"' .github/workflows/blobs.yml
git add .
git commit -m "prebuilts/samsung/e1qzcx: init" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/prebuilts/samsung/r11qxxx prebuilts/samsung
sed -i '/- module: "Galaxy A73 5G (a73xqxx)""/i \          - module: "Galaxy S23 FE (r11qxxx)"\n            device: "r11qxxx"\n            firmware: "SM-S711U1/AIO/358460181039276"' .github/workflows/blobs.yml
git add .
git commit -m "prebuilts/samsung/r11qxxx: init" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/platform/sm7150 platform
git add .
git commit -m "platform/sm7150: init" -m "$CREDIT"
#git push origin sixteenQPR2

rsync -av --inplace --no-compress $SCR/target/m51 target
sed -i 's/m52xq/m51, m52xq/g' .github/workflows/build.yml
sed -i 's|a52sxq|m51|g' .github/workflows/blobs.yml
git add .
git commit -m "target/m51: Initialize Galaxy M51" -m "$CREDIT"
#git push origin sixteenQPR2

cat << 'EOF' >> .github/workflows/build.yml

      - name: Upload ROM to PixelDrain
        env:
          PIXELDRAIN_API_KEY: ${{ secrets.PIXELDRAIN_API_KEY }}
        run: |
          curl -sL https://github.com/jkawamoto/go-pixeldrain/releases/download/v0.7.6/pd_0.7.6_linux_amd64.tar.gz | tar -xz pd
          for ROM in out/UN1CA*.zip out/*target*.zip; do
            echo "Uploading $ROM to PixelDrain..."
            ./pd --api-key "$PIXELDRAIN_API_KEY" upload "$ROM" | sed 's|api/ROM|u|g'
          done
EOF
sed -i '/device/a\        OUTPUT_FILE+="-decrypted"' scripts/build_flashable_zip.sh
# Add --build-rom-zip to make_rom.sh
sed -i 's|./scripts/make_rom.sh|./scripts/make_rom.sh --build-rom-zip|g' .github/workflows/build.yml
# Remove old matrix block
sed -i '/^ *matrix:/,/^ *[^[:space:]]*:/ { /^ *matrix:/d; /^ *target:/d; /^ *[[:space:]]*- [a-z0-9, ]*/d; }' .github/workflows/build.yml
# Replace all matrix.target references with m51
sed -i 's|${{ matrix.target }}|m51|g' .github/workflows/build.yml
# Insert new matrix for decrypted/encrypted builds
sed -i '/^ *strategy:/a \
      matrix:\n        build_type: [encrypted, decrypted]' .github/workflows/build.yml
# Add step to create "disable" file for encrypted builds
sed -i "s%^\([[:space:]]*\)- name: Build ROM%\1- name: Configure encryption state\n\1  if: matrix.build_type == 'encrypted'\n\1  run: |\n\1    source ./buildenv.sh m51\n\1    touch target/m51/patches/dfe/disable\n\1    sed -i 's|decrypted|encrypted|g' scripts/build_flashable_zip.sh\n\n\1- name: Build ROM%" .github/workflows/build.yml
# Commit and push changes
git add .
git commit -m ".github/workflows/build.yml: en/decrypted build & upload to 'PixelDrain'" -m "$CREDIT"
git push origin sixteenQPR2