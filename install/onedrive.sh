echo "🚀 Installing dlang"

LATEST=$(curl -fsSL https://downloads.dlang.org/releases/2.x/ \
  | grep -Eo 'href="/releases/2.x/2\.[0-9]+\.[0-9]+/' \
  | grep -Eo '2\.[0-9]+\.[0-9]+' \
  | sort -V \
  | tail -1)
echo "$LATEST"

DMD_VERSION=$(dmd --version | sed -nE 's/.*v([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

if [ "$INSTALLED_VERSION" = "$LATEST" ]; then
  echo "✅ Latest DMD version installed: $INSTALLED_VERSION"
else
  echo "❌ DMD version mismatch: installed=$INSTALLED_VERSION, expected=$LATEST updating"
  
  cd /tmp
  sudo curl -LO https://downloads.dlang.org/releases/2.x/$LATEST/dmd_$LATEST-0_amd64.deb
  sudo dpkg -i dmd_$LATEST-0_amd64.deb
  echo "✅ dlang installed"
fi

echo "🚀 Installing onedrive (from latest GitHub release tar.gz)"

cd /tmp

# Ensure gh is available
if ! command -v gh >/dev/null 2>&1; then
  echo "❌ GitHub CLI (gh) not found. Please install: https://cli.github.com/" >&2
  exit 1
fi

LATEST_VERSION=$(gh release view --repo abraunegg/onedrive --json tagName --jq .tagName)
echo "📥 Latest onedrive version: $LATEST_VERSION"

ONEDRIVE_VERSION=$(onedrive --version 2>/dev/null | sed -nE 's/.*v?([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

if [ "$LATEST_VERSION" != "v$ONEDRIVE_VERSION" ]; then
    
    echo "❌ Onedrive version mismatch: installed=$ONEDRIVE_VERSION, expected=$LATEST_VERSION updating"

    # Download latest release tar.gz asset for abraunegg/onedrive
    DOWNLOAD_DIR="/tmp/onedrive_dl"
    mkdir -p "$DOWNLOAD_DIR"
    cd $DOWNLOAD_DIR
    gh release download --repo abraunegg/onedrive --clobber --archive "tar.gz"

    # Pick the most recent tar.gz (there should usually be one)
    TARBALL=$(ls -1t "$DOWNLOAD_DIR"/*.tar.gz 2>/dev/null | head -n1)
    if [ -z "$TARBALL" ]; then
        echo "❌ No tar.gz asset found in latest release" >&2
    exit 1
    fi
        echo "📦 Downloaded: $TARBALL"

    # Extract into /tmp and enter extracted folder
    EXTRACT_DIR="/tmp/onedrive_src"
    rm -rf "$EXTRACT_DIR"
    mkdir -p "$EXTRACT_DIR"
    tar -xzf "$TARBALL" -C "$EXTRACT_DIR"

    # Enter extracted source directory (first top-level folder)
    SRCDIR=$(find "$EXTRACT_DIR" -mindepth 1 -maxdepth 1 -type d | head -n1)
    if [ -z "$SRCDIR" ]; then
        echo "❌ Unable to locate extracted source directory" >&2
        exit 1
    fi

    echo "📂 Using source: $SRCDIR"

    cd "$SRCDIR"

    echo "🚀 Building and installing OneDrive"

    ./configure
    make clean
    make -j"$(nproc)"
    sudo make install

    echo "✅ OneDrive installed"
else
    echo "Skipping OneDrive Update"
fi
