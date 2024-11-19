#TeXLive
cd /tmp # working directory of your choice
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz # or curl instead of wget
tar xf install-tl-unx.tar.gz
folder=$(fd "^install-tl-[0-9]+" $(pwd))
cd $folder
sudo perl ./install-tl --no-interaction # as root or with writable destination
folder=$(fd "/usr/local/texlive/[0-9]+/bin/x86_64-linux" /)

# #Finally, prepend /usr/local/texlive/YYYY/bin/PLATFORM to your PATH,# 
# e.g., /usr/local/texlive/2023/bin/x86_64-linux

sudo apt-get install -y \
    texstudio \
    jabref
    
# installed by script above  
# texlive-latex-recommended texlive-science texlive-fonts-extra texlive-full

sudo $(which tlmgr) init-usertree
sudo $(which tlmgr) update --self

sudo $(which tlmgr) install \
    koma-script \
    dirtree \
    algpseudocodex \
    algorithmicx \
    fifo-stack \
    varwidth \
    totcount \
    tabto-ltx \
    pgf \
    tikzmark \
    algorithms \
    setspace \
    cmap \
    bbm \
    caption \
    multirow \
    paralist \
    babel-czech \
    easyreview \
    soul \
    xcolor \
    todonotes \
    standalone \
    pgfplots \
    tkz-euclide \
    xpatch \
    makecell \
    listings \
    minted \
    siunitx \
    algorithm2e \
    ifoddpage \
    relsize \
    algpseudocodex \
    mwe \
    comment

# edit .zshrc file ins
echo "Add this to PATH in the open file - $folder"
kate ~/.zshrc