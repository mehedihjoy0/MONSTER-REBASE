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
git cherry-pick -X theirs 26369475a19665113c1884ed79d3f65743fb30fb^..ffe9aa36b7508ccaed8ae26fefba58ecdfb9bc1e
git push origin sixteenQPR2