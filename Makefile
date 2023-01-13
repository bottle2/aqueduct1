PAGES=bookmarks.html vehicle-building-games.html

all:$(PAGES)

bookmarks.html:bookmarks
	./$? > $@
vehicle-building-games.html:vehicle-building-games
	./$? > $@

clean:
	rm -f $(PAGES) bookmarks vehicle-building-games
