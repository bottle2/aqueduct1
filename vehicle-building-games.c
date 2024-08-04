#include <assert.h>
#include <ctype.h>
#include <limits.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "expands.h"
#include "html.h"

#define TITLE "List of vehicle building games"
#define STYLES

#define LOCATION_XS(X)                        \
X(ADDICTING_GAMES  , "Addicting Games"  , NIL) \
X(AMAZON           , "Amazon"           , NIL) \
X(APP_STORE        , "App Store"        , NIL) \
X(ARMOR_GAMES      , "Armor Games"      , NIL) \
X(BUBBLEBOX        , "Bubblebox"        , NIL) \
X(CONTENT          , "content"          , NIL) \
X(CRAZY_GAMES      , "Crazy Games"      , NIL) \
X(CURSEFORGE       , "CurseForge"       , NIL) \
X(DEVIANTART       , "DeviantArt"       , NIL) \
X(DISCORD          , "Discord"          , NIL) \
X(FACEBOOK         , "Facebook"         , NIL) \
X(FASTSWF          , "fastSWF"          , NIL) \
X(FLONGA           , "Flonga"           , NIL) \
X(FORUM            , "forum"            , NIL) \
X(FREENODE         , "Freenode"         , NIL) \
X(GITHUB           , "GitHub"           , NIL) \
X(GOG              , "GOG.com"          , NIL) \
X(HUMBLE_STORE     , "Humble Store"     , NIL) \
X(INDIE_DB         , "Indie DB"         , NIL) \
X(INSTAGRAM        , "Instagram"        , NIL) \
X(ITCH_IO          , "itch.io"          , NIL) \
X(JAYISGAMES       , "JayIsGames"       , NIL) \
X(KICKSTARTER      , "Kickstarter"      , NIL) \
X(KONGREGATE       , "Kongregate"       , NIL) \
X(MAX_GAMES        , "Max Games"        , NIL) \
X(MICROSOFT_STORE  , "Microsoft Store"  , NIL) \
X(MOD_DB           , "Mod DB"           , NIL) \
X(MY_ABANDONWARE   , "My Abandonware"   , NIL) \
X(NEWGROUNDS       , "Newgrounds"       , NIL) \
X(NITROME          , "Nitrome"          , NIL) \
X(NOT_DOPPLER      , "Not Doppler"      , NIL) \
X(OCULUS_STORE     , "Oculus Store"     , NIL) \
X(ORIGIN           , "Origin"           , NIL) \
X(PATREON          , "Patreon"          , NIL) \
X(PLAYSTATION_STORE, "Playstation Store", NIL) \
X(PLAY_STORE       , "Play Store"       , NIL) \
X(QUAKENET         , "Quakenet"         , NIL) \
X(REDDIT           , "Reddit"           , NIL) \
X(RIZON            , "Rizon"            , NIL) \
X(SILVER_GAMES     , "Silver Games"     , NIL) \
X(SITE             , "site"             , NIL) \
X(SOUNDCLOUD       , "SoundCloud"       , NIL) \
X(SOURCEFORGE      , "SourceForge"      , NIL) \
X(STEAM            , "Steam"            , NIL) \
X(TRELLO           , "Trello"           , NIL) \
X(TUMBLR           , "Tumblr"           , NIL) \
X(TV_TROPES        , "TV Tropes"        , NIL) \
X(TWITCH           , "Twitch"           , NIL) \
X(TWITTER          , "Twitter"          , NIL) \
X(WIKI             , "wiki"             , NIL) \
X(WIKIPEDIA        , "Wikipedia"        , NIL) \
X(WINDOWS_STORE    , "Windows Store"    , NIL) \
X(XBOX             , "Xbox"             , NIL) \
X(YOUTUBE          , "YouTube"          , NIL) \
X(NO_LOCATION = -1 , NULL               , NIL)

enum               location      { LOCATION_XS(AS_COMMA_FIRST)  };
static const char *locations[] = { LOCATION_XS(AS_COMMA_SECOND) };

#define ATTRIBUTE_XS(X)            \
X(ARCHIVE = 1 << 0, "archive", NIL) \
X(MENTION = 1 << 1, "mention", NIL) \
X(NO_ATTRIBUTE = 0, NULL     , NIL)

enum               attribute      { ATTRIBUTE_XS(AS_COMMA_FIRST)  };
static const char *attributes[] = { ATTRIBUTE_XS(AS_COMMA_SECOND) };

#define REFERENCE_XS(X)                                                                            \
X("https://steamcommunity.com/app/301520/discussions/2/1679190184072055800/"                      , \
  "My starting point and where the idea of writing this up came from"                             ) \
X("https://reddit.com/r/Robocraft/comments/4ixdna/a_big_list_of_vehicle_building_games/"          , \
  "This Reddit thread at r/Robocraft"                                                             ) \
X("https://reddit.com/r/Games/comments/4ixqqc/big_list_of_vehicle_building_games/"                , \
  "The same thread above reposted at r/Games"                                                     ) \
X("https://reddit.com/r/Robocraft/comments/87hoff/any_good_rc_clones_for_a_guy_who_likes_the_old/", \
  "This thread at r/Robocraft"                                                                    ) \
X("https://reddit.com/r/RobocraftRefugees/"                                                       , \
  "This interesting subreddit"                                                                    )

#define REFERENCE_X_AS_LIST_ITEM_ANCHOR(URL, TEXT) INDENT "\t<li><a href=\"" URL "\">" TEXT "</a></li>\n"

#define REFERENCES                                                     \
INDENT "<p>Previous efforts to list many vehicle building games:</p>\n" \
INDENT "<ul>\n"                                                         \
REFERENCE_XS(REFERENCE_X_AS_LIST_ITEM_ANCHOR)                           \
INDENT "</ul>\n"

static char const *names[] = {
	#define  GAME_X(NAME, ...) NAME,
	#include "vehicle-building-games.inc"
	#undef   GAME_X
};

static char const *notes[] = {
	#define  GAME_X(NAME, NOTE, ...) NOTE,
	#include "vehicle-building-games.inc"
	#undef   GAME_X
};

static char const *footnotes[] = {
	#define  GAME_X(NAME, NOTE, FOOTNOTE, ...) FOOTNOTE,
	#include "vehicle-building-games.inc"
	#undef   GAME_X
};

static enum location const *games_locations[] = {
	#define  GAME_X(NAME, NOTE, FOOTNOTE, LOCATION_XS) (enum location const []){LOCATION_XS},
	#define  LOCATION_X(LOCATION, RESOURCES_XS) LOCATION,
	#define  NIL NO_LOCATION
	#include "vehicle-building-games.inc"
	#undef   GAME_X
	#undef   LOCATION_X
	#undef   NIL
};

static enum attribute const **game_location_resource_attributes[] = {
	#define  GAME_X(NAME, NOTE, FOOTNOTE, LOCATION_XS) (enum attribute const *[]){LOCATION_XS},
	#define  LOCATION_X(LOCATION, RESOURCE_XS) (enum attribute const []){RESOURCE_XS},
	#define  RESOURCE_X(ATTRIBUTE, ...) ATTRIBUTE,
	#define  NIL (enum attribute const []){NO_ATTRIBUTE}
	#include "vehicle-building-games.inc"
	#undef   GAME_X
	#undef   LOCATION_X
	#undef   RESOURCE_X
	#undef   NIL
};

static char const ***game_location_resource_indexes[] = {
	#define  GAME_X(NAME, NOTE, FOOTNOTE, LOCATION_XS) (char const **[]){LOCATION_XS},
	#define  LOCATION_X(LOCATION, RESOURCE_XS) (char const *[]){RESOURCE_XS},
	#define  RESOURCE_X(ATTRIBUTE, INDEX, ...) INDEX,
	#define  NIL NULL
	#include "vehicle-building-games.inc"
	#undef   GAME_X
	#undef   LOCATION_X
	#undef   RESOURCE_X
	#undef   NIL
};

static char const ***game_location_resource_urls[] = {
	#define  GAME_X(NAME, NOTE, FOOTNOTE, LOCATION_XS) (char const **[]){LOCATION_XS},
	#define  LOCATION_X(LOCATION, RESOURCE_XS) (char const *[]){RESOURCE_XS},
	#define  RESOURCE_X(ATTRIBUTE, INDEX, URL) URL,
	#define  NIL NULL
	#include "vehicle-building-games.inc"
	#undef   GAME_X
	#undef   LOCATION_X
	#undef   RESOURCE_X
	#undef   NIL
};

static int const n_game =
	#define  GAME_X(...) + 1
	#include "vehicle-building-games.inc"
	#undef   GAME_X
;

static int const n_location_per_game[] = {
	#define  GAME_X(NAME, NOTE, FOOTNOTE, LOCATION_XS) LOCATION_XS,
	#define  LOCATION_X(...) + 1
	#define  NIL 0
	#include "vehicle-building-games.inc"
	#undef   GAME_X
	#undef   LOCATION_X
	#undef   NIL
};

static int const *n_resource_per_location_per_game[] = {
	#define  GAME_X(NAME, NOTE, FOOTNOTE, LOCATION_XS) (int const []){LOCATION_XS},
	#define  LOCATION_X(LOCATION, RESOURCE_XS) RESOURCE_XS,
	#define  RESOURCE_X(...) + 1
	#define  NIL -1
	#include "vehicle-building-games.inc"
	#undef   GAME_X
	#undef   LOCATION_X
	#undef   RESOURCE_X
	#undef   NIL
};

static void print_str_as_html_id(char const *str);

static int print_footnotes(
	int         footnote_i,
	int         n_footnote,
	char const *ids[],
	bool        is_only_flag,
	char const  prefix[],
	int         starting_flag_i
);

static void print_bitfield(
	unsigned    bitfield,
	char const *flags[],
	char const  prefix[],
	char const  suffix[],
	char const  separator[]
);

static void print_games(void);

static void print_locations(
	int                    n_location,
	int  const             n_resource[],
	char const           **resource_urls[],
	enum location const    game_locations[],
	char const           **resource_indexes[],
	enum attribute const  *resource_attributes[]
);

static void print_first_resource(
	int             n_resource,
	char const      url[],
	char const      location[],
	char const     *index,
	enum attribute  attribute
);

static void print_other_resources(
	int                   n_resource,
	char const           *indexes[],
	char const           *urls[],
	enum attribute const  resource_attributes[]
);

static void print_troff(void);

int main(int argc, char *argv[])
{
	(void)argv;

	if (argc > 1)
	{
		print_troff();
		return EXIT_SUCCESS;
	}

	printf("%s%s%s", HTML_OPEN, HEAD, BODY_OPEN);
	
	print_games();

	printf("%s", REFERENCES);

	static int const n_footnote =
		#define  GAME_X(NAME, NOTE, FOOTNOTE, ...) + (FOOTNOTE != NULL)
		#include "vehicle-building-games.inc"
		#undef   GAME_X
	;

	if (n_footnote > 0) printf(INDENT "<hr />\n");
	print_footnotes(0, n_game, names, false, "\t\t", 0);

	printf("%s%s", BODY_CLOSE, HTML_CLOSE);

	return 0;
}

static void print_str_as_html_id(char const *str)
{
	assert(isalpha(str[0]));
	// Can't handle `str` if not starting with a-Z.

	for (; *str != '\0'; str++)
	{
		if      (isalpha(*str))              putchar(tolower(*str));
		else if (isdigit(*str))              putchar(*str);
		else if (' ' == *str || '-' == *str) putchar('-');
		else if ('&' == *str)                putchar('e');
	}
}

static int print_footnotes(
	int         footnote_i,
	int         n_footnote,
	char const *ids[],
	bool        is_only_flag,
	char const  prefix[],
	int         starting_flag_i
) {
	int footnote_flag = 'a' + starting_flag_i;
	
	for (; footnote_i < n_footnote; footnote_i++)
	{
		if (NULL == footnotes[footnote_i]) continue;

		printf("%s<sup><a href=\"#", prefix);
		print_str_as_html_id(ids[footnote_i]);
		printf("%s\" id=\"", is_only_flag ? "" : "-reverse");
		print_str_as_html_id(ids[footnote_i]);
		printf(
			"%s\">%c</a></sup>",
			is_only_flag ? "-reverse" : "",
			footnote_flag++
		);

		if (!is_only_flag)
		{
			printf("\n%s\n", footnotes[footnote_i]);
			printf(INDENT "<br />\n\n");
		}
	}
	
	return (footnote_flag - 'a' - starting_flag_i);
}

static void print_bitfield(
	unsigned    bitfield,
	char const *flags[],
	char const  prefix[],
	char const  suffix[],
	char const  separator[]
) {
	bool found_flag = false;
	
	for (size_t flag_i = 0; flag_i < (sizeof bitfield) * CHAR_BIT; flag_i++)
	{
		if (bitfield & 1 << flag_i)
		{
			printf("%s%s", found_flag ? separator : prefix, flags[flag_i]);
			found_flag = true;
		}
	}
	
	if (found_flag)
	{
		printf("%s", suffix);
	}
}

static void print_games(void)
{
	printf(INDENT "<ul>\n");
	
	for (int game_i = 0, footnote_i = 0; game_i < n_game; game_i++)
	{
		printf("\t\t\t<li>\n\t\t\t\t%s\n", names[game_i]);
		
		print_locations(
			n_location_per_game[game_i],
			n_resource_per_location_per_game[game_i],
			game_location_resource_urls[game_i],
			games_locations[game_i],
			game_location_resource_indexes[game_i],
			game_location_resource_attributes[game_i]
		);

		if (notes[game_i] != NULL)
		{
			printf("\t\t\t\t(%s", notes[game_i]);
			footnote_i += print_footnotes(
				game_i,
				game_i + 1,
				names,
				true,
				" ",
				footnote_i
			);
			printf(")\n");
		}
		// Note for game.

		printf("\t\t\t</li>\n");
	}
	
	printf(INDENT "</ul>\n");
}

static void print_locations(
	int                    n_location,
	int  const             n_resource[],
	char const           **resource_urls[],
	enum location const    game_locations[],
	char const           **resource_indexes[],
	enum attribute const  *resource_attributes[]
) {
	for (int location_i = 0; location_i < n_location; location_i++)
	{
		printf("\t\t\t\t[");
		
		print_first_resource(
			n_resource[location_i],
			resource_urls[location_i][0],
			locations[game_locations[location_i]],
			resource_indexes[location_i][0],
			resource_attributes[location_i][0]
		);
		
		print_other_resources(
			n_resource[location_i],
			resource_indexes[location_i],
			resource_urls[location_i],
			resource_attributes[location_i]
		);
		
		printf("]\n");
	}
}

static void print_first_resource(
	int             n_resource,
	char const      url[],
	char const      location[],
	char const     *index,
	enum attribute  attribute
) {
	bool many_resources = n_resource > 1;
	
	printf("<a href=\"%s\">%s", url, location);
	
	if (many_resources) printf("<sup>%s</sup>", index ? index : "1");
	
	printf("</a>");
	
	print_bitfield(
		attribute,
		attributes,
		many_resources ? "<sup> (" : " (",
		many_resources ? ")</sup>" : ")",
		", "
	);
}

static void print_other_resources(
	int                   n_resource,
	char const           *indexes[],
	char const           *urls[],
	enum attribute const  resource_attributes[]
) {
	for (int resource_i = 1; resource_i < n_resource; resource_i++)
	{
		char const *index = indexes[resource_i];
		
		printf("\n\t\t\t\t<sup><a href=\"%s\">", urls[resource_i]);
		
		if (index) printf("%s", index);
		else       printf("%d", resource_i + 1);
		
		printf("</a>");
	
		print_bitfield(
			resource_attributes[resource_i], attributes, " (", ")", ", "
		);
		
		printf("</sup>");
	}
}

#define AS_COMMA_FIRST_STRINGIFY(A, ...) #A,
static char const *location_lits[] = {
    LOCATION_XS(AS_COMMA_FIRST_STRINGIFY)
};

static void print_troff(void)
{
    puts(".\\\"Very little effort to match classic groff syntax... we should converge.");
    puts(".\\\"Also some lazy HTML injection am I right?");
    puts(".\\\"And... how about those URLs, eh? should we allow UTF-8 or only percent-encoding? we can't mix, otherwise we will encode the percents themselves");
    puts(".TITLE \"" TITLE "\"\n.HEADING 1 \"" TITLE "\"");

    for (int i = 0; i < n_game; i++)
    {
        printf(".GAME %s\n", names[i]);

        int widest = 0;

        for (int j = 0; j < n_location_per_game[i]; j++)
        {
            int len = strlen(location_lits[games_locations[i][j]]);

            if (len > widest)
                widest = len;
        }

        for (int j = 0; j < n_location_per_game[i]; j++)
        {
            char const *location = location_lits[games_locations[i][j]];

            for (int k = 0; k < n_resource_per_location_per_game[i][j]; k++)
            {
                unsigned attr = game_location_resource_attributes[i][j][k];
                // XXX hardcoded PoS
                if (attr >= 2)
                    puts(".MENTION");
                if (1 == attr || 3 == attr)
                    puts(".ARCHIVE"); // XXX Improve in the future!

                char const *index = game_location_resource_indexes[i][j][k];

                if (index)
                    printf(".LABEL %s\n", index);

                printf(".LOC %-*s %s\n", widest, location,
                    game_location_resource_urls[i][j][k]);

                // XXX Opinion. For consistency, all characteristics should be added after our before, no mixture!!!!
                // Or not! What feels more natural? What feels more natural.
                // XXX Further insight. If comes before, state machine could
                // enforce next command, but coming after, we can modify object
                // directly.
            }
        }

        if (notes[i])
        {
            puts(".NOTE");
            puts(notes[i]);
            if (footnotes[i])
            {
                puts(".FS"); // syntax from memorandum macros
                puts(footnotes[i]); // XXX hardcoded href, should replace with commands
                puts(".FE");
            }
        }
    }
    puts(".PP\nPrevious efforts to list many vehicle building games:");
    puts(REFERENCES); // XXX wow what a lazy move
}
