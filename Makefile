all:vehicle-building-games.html

vehicle-building-games.html:vehicle-building-games
	./$? > $@

clean:
	rm -f vehicle-building-games{,.html}
