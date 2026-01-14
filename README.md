# Linux Scripts

Some useful scripts for Linux

## First install

Run manually:

```bash
sudo apt install -y git zsh
cd /tmp
git clone https://github.com/JanCaha/linux-scripts.git
PATH=$PATH:/tmp/linux-scripts:/tmp/linux-scripts/python_programs
```

## Git-crypt

To encrypt sensitive files in the repository:

1. **Install git-crypt:**
```bash
sudo apt install git-crypt
```

2. **Initialize encryption in the repo:**
```bash
git-crypt init
```

3. **Add files to encrypt** by creating/updating `.gitattributes`:
```
secrets.txt filter=git-crypt diff=git-crypt
*.secret filter=git-crypt diff=git-crypt
```

4. **Commit and push:**
```bash
git add .gitattributes
git commit -m "Add encryption"
git push
```

5. **Share the key with collaborators:**
```bash
git-crypt export-key /tmp/repo.key
# Send the key securely, then on their machine:
git-crypt unlock /path/to/repo.key
```
