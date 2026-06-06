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
rsync -av --inplace --no-compress prebuilts/samsung/r11sxxx/* prebuilts/samsung/r11qxxx
rsync -av --inplace --no-compress $SCR/prebuilts/samsung/r11qxxx/.current prebuilts/samsung/r11qxxx
sed -i 's|r11sxxx|r11qxxx|g' platform/sm7150/patches/_desixtification/customize.sh
# Commit and push changes
git add .
git commit -m "prebuilts/samsung/r11qxxx: add more blobs" -m "$CREDIT"
git push origin sixteenQPR2