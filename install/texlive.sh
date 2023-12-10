#TeXLive
sudo apt-get install -y \
    texlive-latex-recommended \
    texlive-science \
    texlive-fonts-extra \
    texlive-full \
    texstudio \
    jabref

tlmgr init-usertree
tlmgr update --self

tlmgr install koma-script \
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