apply:
	cp -r $(CURDIR) ~/.config/mpv/scripts/ --remove-destination

test:
	# use the apply command to copy the files then open mpv
	$(MAKE) apply && mpv "/home/none/Downloads/longest_ride/The.Longest.Ride.2015.720p.BluRay.x264.YIFY.mp4"

.PHONEY:
	apply
