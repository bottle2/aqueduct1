#ifndef HTML_H
#define HTML_H

// Expects macro TITLE to be defined by includer.

#define HEAD                                                                      \
"\t<head>\n"                                                                       \
"\t\t<meta charset=\"UTF-8\">\n"                                                   \
"\t\t<link rel=\"icon\" type=\"image/svg+xml\" href=\"./logo.svg\">\n"             \
"\t\t<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n" \
"\t\t<title>" TITLE " - aqueduct1</title>\n"                                       \
STYLES                                                                             \
"\t</head>\n"

#define BODY_OPEN  "\t<body>\n\t\t<h1>" TITLE "</h1>\n"
#define BODY_CLOSE "\t</body>\n"

#define HTML_OPEN  "<!DOCTYPE html>\n<html lang=\"en\">\n"
#define HTML_CLOSE "</html>\n"

#define INDENT "\t\t"

#endif

