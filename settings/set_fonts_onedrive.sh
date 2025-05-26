# fonts folder from OneDrive
if [ -d ~/.local/share/fonts/ ]; then
ln -s ~/OneDrive/Fonts/fonts_folder/ ~/.local/share/fonts
	read -r response
	if [ "$response" = "y" ]; then
		tar -czf ~/fonts_backup.tar.gz ~/.local/share/fonts/
		echo "Backup created at ~/fonts_backup.tar.gz"
	fi
	echo "Are you sure you want to delete ~/.local/share/fonts/? (y/n)"
	read -r confirm
	if [ "$confirm" = "y" ]; then
		rm -rf ~/.local/share/fonts/
		echo "Directory deleted."
	else
		echo "Deletion canceled."
	fi
else
	echo "The directory ~/.local/share/fonts/ does not exist."
fi

ln -sd ~/OneDrive/Fonts/fonts_folder/ ~/.local/share/fonts

# Update the font cache system-wide to reflect the changes
sudo fc-cache -v