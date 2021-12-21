#include <stdio.h>

#include "html.h"

#define TITLE "My bookmarks"

#define STYLES                             \
"\t<style>\n"                               \
"\t\tbody {\n"                              \
"\t\t\tfont-family:sans-serif;\n"           \
"\t\t}\n"                                   \
"\t\t\n"                                    \
"\t\tarticle {\n"                           \
"\t\t\tdisplay:        flex;\n"             \
"\t\t\tflex-direction: row;\n"              \
"\t\t\tflex-wrap:      wrap;\n"             \
"\t\t\tjustify-content:space-around;\n"     \
"\t\t}\n"                                   \
"\t\t\n"                                    \
"\t\tsection {\n"                           \
"\t\t\tflex:         1 1 auto;\n"           \
"\t\t\tborder:       medium solid black;\n" \
"\t\t\tborder-radius:25px;\n"               \
"\t\t\tpadding:      25px;\n"               \
"\t\t\tmargin:       25px;\n"               \
"\t\t}\n"                                   \
"\t\t\n"                                    \
"\t\th1 {\n"                                \
"\t\t\ttext-align: center;\n"               \
"\t\t}\n"                                   \
"\t</style>"

static int const sections_level[] = {
	#define SECTION_X(LEVEL, ...) LEVEL,
	#include "bookmarks.xs"
	#undef SECTION_X
};

static char const *sections_header[] = {
	#define SECTION_X(LEVEL, HEADER, ...) HEADER,
	#include "bookmarks.xs"
	#undef SECTION_X
};

static char const **sections_links_url[] = {
	#define NIL NULL
	#define SECTION_X(LEVEL, HEADER, LINKS_XS) (char const *[]){LINKS_XS},
	#define LINK_X(URL, ...) URL,
	#include "bookmarks.xs"
	#undef LINK_X
	#undef SECTION_X
	#undef NIL
};

static char const **sections_links_anchor[] = {
	#define NIL NULL
	#define SECTION_X(LEVEL, HEADER, LINKS_XS) (char const *[]){LINKS_XS},
	#define LINK_X(URL, ANCHOR) ANCHOR,
	#include "bookmarks.xs"
	#undef LINK_X
	#undef SECTION_X
	#undef NIL
};

static int n_section =
	#define SECTION_X(...) + 1
	#include "bookmarks.xs"
	#undef SECTION_X
;

static int const n_section_link[] = {
	#define NIL 0
	#define SECTION_X(LEVEL, HEADER, LINKS_XS) LINKS_XS,
	#define LINK_X(...) + 1
	#include "bookmarks.xs"
	#undef LINK_X
	#undef SECTION_X
	#undef NIL
};

int main(void)
{
	printf("%s%s%s%s", HTML_OPEN, HEAD, BODY_OPEN, "\t\t<article>\n");
	
	for (int section_i = 0; section_i < n_section; section_i++)
	{
		if (1 == sections_level[section_i])
		{
			printf("%s", "\t\t<section>\n");
		}
		
		printf(
			"\t\t\t<h%d>%s</h%d>\n",
			sections_level[section_i] + 1,
			sections_header[section_i],
			sections_level[section_i] + 1
		);
		
		for (int link_i = 0; link_i < n_section_link[section_i]; link_i++)
		{
			printf(
				"\t\t\t<li><a href=\"%s\">\n\t\t\t\t%s\n\t\t\t</li></a>\n",
				sections_links_url[section_i][link_i],
				sections_links_anchor[section_i][link_i]
			);
		}
		
		if (section_i == n_section - 1 || 1 == sections_level[section_i + 1])
		{
			printf("%s", "\t\t</section>\n");
		}
	}
	
	printf("%s%s%s", "\t\t<article>\n", BODY_CLOSE, HTML_CLOSE);
	
	return 0;
}
