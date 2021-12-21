# Uncomment macros if are a:

# Linux user
#E=
#S=/

# Windows user
E=.exe
S=\\
# Also do not use the clean target

PAGES=bookmarks.html vehicle-building-games.html

all:$(PAGES)

bookmarks.html:bookmarks$E
	.$S$? > $@

vehicle-building-games.html:vehicle-building-games$E
	.$S$? > $@

clean:
	rm -f $(PAGES) bookmarks vehicle-building-games
