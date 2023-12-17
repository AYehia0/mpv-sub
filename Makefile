apply:
	cp -r $(CURDIR) ~/.config/mpv/scripts/ --remove-destination

.PHONEY:
	apply
