TIZEN_STUDIO_LOC=$HOME/Applications/tizen-studio
TIZEN=$TIZEN_STUDIO_LOC/tools/ide/bin/tizen
SDB=$TIZEN_STUDIO_LOC/tools/sdb

cd /tmp
git clone -b release-10.9.z https://github.com/jellyfin/jellyfin-web.git
git clone https://github.com/jellyfin/jellyfin-tizen.git

cd jellyfin-web
SKIP_PREPARE=1 npm ci --no-audit
USE_SYSTEM_FONTS=1 npm run build:production

cd ..

cd jellyfin-tizen
JELLYFIN_WEB_DIR=../jellyfin-web/dist npm ci --no-audit

$TIZEN build-web -e ".*" -e gulpfile.js -e README.md -e "node_modules/*" -e "package*.json" -e "yarn.lock"
$TIZEN package -t wgt -o . -- .buildResult

# add IP of TV
$SDB connect 

$SDB devices

# get id from list above
TV_ID=
$TIZEN install-permit -t $TV_ID
$TIZEN install -n Jellyfin.wgt -t $TV_ID
