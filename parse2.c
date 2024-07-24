#line 1 "parse2.rl"
#include <assert.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "code.h"
#include "movie.h"
#include "parse.h"

#ifdef WIN32
#define STRNDUP_IMPL
// XXX piss piss piss piss cock piss piss piss piss piss piss fuck fuck
// why can't MSYS2 declare strndup?????????????????????????????????????
static char *strndup(const char *s, size_t len)
{
	char *copy = malloc(len + 1);
	if (NULL == copy)
		return NULL;
	size_t i = 0;
	for (; i < len && s[i] != '\0'; i++)
	copy[i] = s[i];
	copy[i] = '\0';
	return copy;
}
#endif


#line 28 "parse2.rl"



#line 35 "parse2.c"
static const signed char _movies_actions[] = {
	0, 1, 0, 1, 1, 1, 4, 1,
	6, 1, 7, 1, 8, 1, 11, 1,
	12, 1, 13, 1, 14, 1, 16, 1,
	17, 1, 18, 1, 19, 1, 21, 1,
	22, 1, 24, 2, 0, 1, 2, 2,
	1, 2, 5, 8, 2, 9, 10, 2,
	16, 17, 2, 20, 10, 3, 3, 10,
	8, 3, 15, 10, 8, 3, 20, 10,
	8, 4, 23, 10, 25, 8, 0
};

static const short _movies_key_offsets[] = {
	0, 0, 5, 6, 7, 8, 9, 10,
	11, 15, 21, 25, 30, 33, 36, 38,
	39, 40, 44, 51, 52, 54, 56, 58,
	60, 62, 64, 66, 72, 78, 80, 82,
	84, 88, 92, 93, 94, 95, 96, 97,
	101, 106, 109, 112, 114, 115, 117, 118,
	122, 131, 136, 140, 144, 148, 152, 0
};

static const unsigned char _movies_trans_keys[] = {
	72u, 77u, 80u, 84u, 92u, 69u, 65u, 68u,
	73u, 78u, 71u, 9u, 32u, 11u, 13u, 9u,
	32u, 11u, 13u, 49u, 54u, 9u, 32u, 11u,
	13u, 9u, 32u, 34u, 11u, 13u, 10u, 34u,
	92u, 10u, 34u, 92u, 34u, 92u, 79u, 86u,
	9u, 32u, 11u, 13u, 9u, 32u, 95u, 11u,
	13u, 65u, 90u, 116u, 48u, 57u, 48u, 57u,
	48u, 57u, 48u, 57u, 48u, 57u, 48u, 57u,
	48u, 57u, 9u, 32u, 11u, 13u, 48u, 57u,
	9u, 32u, 11u, 13u, 48u, 57u, 48u, 57u,
	48u, 57u, 48u, 57u, 9u, 32u, 11u, 13u,
	10u, 32u, 9u, 13u, 80u, 73u, 84u, 76u,
	69u, 9u, 32u, 11u, 13u, 9u, 32u, 34u,
	11u, 13u, 10u, 34u, 92u, 10u, 34u, 92u,
	34u, 92u, 34u, 10u, 46u, 10u, 10u, 32u,
	9u, 13u, 10u, 32u, 95u, 9u, 13u, 48u,
	57u, 65u, 90u, 10u, 32u, 116u, 9u, 13u,
	10u, 32u, 9u, 13u, 10u, 32u, 9u, 13u,
	10u, 32u, 9u, 13u, 10u, 32u, 9u, 13u,
	10u, 0u
};

static const signed char _movies_single_lengths[] = {
	0, 5, 1, 1, 1, 1, 1, 1,
	2, 2, 2, 3, 3, 3, 2, 1,
	1, 2, 3, 1, 0, 0, 0, 0,
	0, 0, 0, 2, 2, 0, 0, 0,
	2, 2, 1, 1, 1, 1, 1, 2,
	3, 3, 3, 2, 1, 2, 1, 2,
	3, 3, 2, 2, 2, 2, 1, 0
};

static const signed char _movies_range_lengths[] = {
	0, 0, 0, 0, 0, 0, 0, 0,
	1, 2, 1, 1, 0, 0, 0, 0,
	0, 1, 2, 0, 1, 1, 1, 1,
	1, 1, 1, 2, 2, 1, 1, 1,
	1, 1, 0, 0, 0, 0, 0, 1,
	1, 0, 0, 0, 0, 0, 0, 1,
	3, 1, 1, 1, 1, 1, 0, 0
};

static const short _movies_index_offsets[] = {
	0, 0, 6, 8, 10, 12, 14, 16,
	18, 22, 27, 31, 36, 40, 44, 47,
	49, 51, 55, 61, 63, 65, 67, 69,
	71, 73, 75, 77, 82, 87, 89, 91,
	93, 97, 101, 103, 105, 107, 109, 111,
	115, 120, 124, 128, 131, 133, 136, 138,
	142, 149, 154, 158, 162, 166, 170, 0
};

static const signed char _movies_cond_targs[] = {
	2, 15, 34, 35, 44, 0, 3, 0,
	4, 0, 5, 0, 6, 0, 7, 0,
	8, 0, 9, 9, 9, 0, 9, 9,
	9, 10, 0, 11, 11, 11, 0, 11,
	11, 12, 11, 0, 0, 0, 14, 13,
	0, 47, 14, 13, 13, 13, 0, 16,
	0, 17, 0, 18, 18, 18, 0, 18,
	18, 48, 18, 48, 0, 20, 0, 21,
	0, 22, 0, 23, 0, 24, 0, 25,
	0, 26, 0, 27, 0, 28, 28, 28,
	27, 0, 28, 28, 28, 29, 0, 30,
	0, 31, 0, 32, 0, 33, 33, 33,
	0, 0, 33, 33, 50, 52, 0, 36,
	0, 37, 0, 38, 0, 39, 0, 40,
	40, 40, 0, 40, 40, 41, 40, 0,
	0, 0, 43, 42, 0, 53, 43, 42,
	42, 42, 0, 54, 0, 45, 1, 46,
	45, 46, 45, 47, 47, 0, 45, 49,
	48, 49, 48, 48, 0, 45, 49, 19,
	49, 0, 45, 51, 51, 50, 45, 51,
	51, 50, 45, 52, 52, 0, 45, 53,
	53, 0, 45, 54, 0, 1, 2, 3,
	4, 5, 6, 7, 8, 9, 10, 11,
	12, 13, 14, 15, 16, 17, 18, 19,
	20, 21, 22, 23, 24, 25, 26, 27,
	28, 29, 30, 31, 32, 33, 34, 35,
	36, 37, 38, 39, 40, 41, 42, 43,
	44, 45, 46, 47, 48, 49, 50, 51,
	52, 53, 54, 0
};

static const signed char _movies_cond_actions[] = {
	0, 0, 0, 0, 0, 9, 0, 9,
	0, 9, 0, 9, 0, 9, 0, 9,
	5, 9, 0, 0, 0, 19, 0, 0,
	0, 15, 19, 0, 0, 0, 19, 0,
	0, 0, 0, 13, 13, 13, 0, 3,
	13, 0, 0, 3, 3, 3, 13, 0,
	9, 0, 9, 7, 7, 7, 21, 0,
	0, 3, 0, 3, 21, 0, 23, 29,
	23, 29, 23, 29, 23, 29, 23, 29,
	23, 29, 23, 29, 23, 0, 0, 0,
	29, 25, 0, 0, 0, 31, 25, 31,
	25, 31, 25, 31, 25, 0, 0, 0,
	27, 27, 0, 0, 3, 0, 9, 0,
	9, 0, 9, 0, 9, 0, 9, 0,
	0, 0, 9, 0, 0, 0, 0, 13,
	13, 13, 0, 3, 13, 0, 0, 3,
	3, 3, 13, 0, 9, 1, 1, 35,
	53, 3, 57, 0, 0, 17, 61, 50,
	3, 50, 3, 3, 47, 11, 0, 33,
	0, 23, 65, 0, 0, 3, 65, 0,
	0, 38, 41, 0, 0, 17, 44, 0,
	0, 17, 0, 0, 0, 9, 9, 9,
	9, 9, 9, 9, 19, 19, 19, 13,
	13, 13, 13, 9, 9, 21, 21, 23,
	23, 23, 23, 23, 23, 23, 23, 25,
	25, 25, 25, 25, 27, 27, 9, 9,
	9, 9, 9, 9, 13, 13, 13, 13,
	9, 0, 53, 57, 61, 11, 65, 65,
	41, 44, 0, 0
};

static const short _movies_eof_trans[] = {
	173, 174, 175, 176, 177, 178, 179, 180,
	181, 182, 183, 184, 185, 186, 187, 188,
	189, 190, 191, 192, 193, 194, 195, 196,
	197, 198, 199, 200, 201, 202, 203, 204,
	205, 206, 207, 208, 209, 210, 211, 212,
	213, 214, 215, 216, 217, 218, 219, 220,
	221, 222, 223, 224, 225, 226, 227, 0
};

static const int movies_start = 45;

static const int movies_en_main = 45;


#line 30 "parse2.rl"


struct parser parser_init(void)
{
	struct parser it = {.buf = NULL, .title = NULL};
	struct parser *parser = &it;
	
#line 198 "parse2.c"
	{
		parser->cs = (int)movies_start;
	}
	
#line 36 "parse2.rl"
	
	return it;
}

void parser_del(struct parser *parser)
{
	free(parser->buf);
	*parser = (struct parser){0};
}

static enum code parse_buf(struct parser *parser, int c)
{
	if (0 == parser->cap)
		{
		assert(0    == parser->len);
		assert(NULL == parser->buf);
		
		if (NULL == (parser->buf = malloc(20)))
			return CODE_ENOMEM;
		else
			{
			parser->cap = 20;
		}
	}
	else if (parser->len == parser->cap - 1)
		{
		char *new = realloc(parser->buf, parser->cap += 20);
		if (new != NULL)
			parser->buf = new;
		else
			{
			free(parser->buf);
			parser->len = 0;
			parser->cap = 0;
			return CODE_ENOMEM;
		}
	}
	
	assert(parser->len < parser->cap - 1);
	
	parser->buf[parser->len++] = c;
	parser->buf[parser->len] = '\0';
	
	return CODE_OKAY;
}

enum code parse(struct parser *parser, unsigned char *p, int len, struct movies *movies)
{
	unsigned char *pe  = 0 == len ? p : p + len;
	unsigned char *eof = 0 == len ? p : NULL;
	
	enum code code = CODE_OKAY;
	
	
#line 258 "parse2.c"
	{
		int _klen;
		unsigned int _trans = 0;
		const unsigned char * _keys;
		const signed char * _acts;
		unsigned int _nacts;
		_resume: {}
		if ( p == pe && p != eof )
			goto _out;
		if ( p == eof ) {
			if ( _movies_eof_trans[parser->cs] > 0 ) {
				_trans = (unsigned int)_movies_eof_trans[parser->cs] - 1;
			}
		}
		else {
			_keys = ( _movies_trans_keys + (_movies_key_offsets[parser->cs]));
			_trans = (unsigned int)_movies_index_offsets[parser->cs];
			
			_klen = (int)_movies_single_lengths[parser->cs];
			if ( _klen > 0 ) {
				const unsigned char *_lower = _keys;
				const unsigned char *_upper = _keys + _klen - 1;
				const unsigned char *_mid;
				while ( 1 ) {
					if ( _upper < _lower ) {
						_keys += _klen;
						_trans += (unsigned int)_klen;
						break;
					}
					
					_mid = _lower + ((_upper-_lower) >> 1);
					if ( ( (*( p))) < (*( _mid)) )
						_upper = _mid - 1;
					else if ( ( (*( p))) > (*( _mid)) )
						_lower = _mid + 1;
					else {
						_trans += (unsigned int)(_mid - _keys);
						goto _match;
					}
				}
			}
			
			_klen = (int)_movies_range_lengths[parser->cs];
			if ( _klen > 0 ) {
				const unsigned char *_lower = _keys;
				const unsigned char *_upper = _keys + (_klen<<1) - 2;
				const unsigned char *_mid;
				while ( 1 ) {
					if ( _upper < _lower ) {
						_trans += (unsigned int)_klen;
						break;
					}
					
					_mid = _lower + (((_upper-_lower) >> 1) & ~1);
					if ( ( (*( p))) < (*( _mid)) )
						_upper = _mid - 2;
					else if ( ( (*( p))) > (*( _mid + 1)) )
						_lower = _mid + 2;
					else {
						_trans += (unsigned int)((_mid - _keys)>>1);
						break;
					}
				}
			}
			
			_match: {}
		}
		parser->cs = (int)_movies_cond_targs[_trans];
		
		if ( _movies_cond_actions[_trans] != 0 ) {
			
			_acts = ( _movies_actions + (_movies_cond_actions[_trans]));
			_nacts = (unsigned int)(*( _acts));
			_acts += 1;
			while ( _nacts > 0 ) {
				switch ( (*( _acts)) )
				{
					case 0:  {
						{
#line 94 "parse2.rl"
							parser->nl++; }
						
#line 341 "parse2.c"
						
						break; 
					}
					case 1:  {
						{
#line 96 "parse2.rl"
							
							if ((code = parse_buf(parser, (( (*( p)))))) != CODE_OKAY)
							{p += 1; goto _out; }
						}
						
#line 353 "parse2.c"
						
						break; 
					}
					case 2:  {
						{
#line 101 "parse2.rl"
							
							if ((code = parse_buf(parser, ' ')) != CODE_OKAY)
							{p += 1; goto _out; }
						}
						
#line 365 "parse2.c"
						
						break; 
					}
					case 3:  {
						{
#line 106 "parse2.rl"
							
							parser->e.type = TEXT;
							if (!(parser->e.text = strndup(parser->buf, parser->len)))
							{
								code = CODE_ENOMEM;
								{p = p - 1; } {p += 1; goto _out; }
							}
						}
						
#line 381 "parse2.c"
						
						break; 
					}
					case 4:  {
						{
#line 114 "parse2.rl"
							parser->e.type = HEADING; }
						
#line 390 "parse2.c"
						
						break; 
					}
					case 5:  {
						{
#line 115 "parse2.rl"
							parser->e.type = PP;      }
						
#line 399 "parse2.c"
						
						break; 
					}
					case 6:  {
						{
#line 116 "parse2.rl"
							parser->e.type = MOV;     }
						
#line 408 "parse2.c"
						
						break; 
					}
					case 7:  {
						{
#line 117 "parse2.rl"
							parser->e.type = INVALID; puts("achei inválido"); }
						
#line 417 "parse2.c"
						
						break; 
					}
					case 8:  {
						{
#line 119 "parse2.rl"
							
							assert(0 == parser->len && '\0' == parser->buf[0]);
							
							struct element *novo = malloc(sizeof (*novo));
							
							if (NULL == novo)
							{
								code = CODE_ENOMEM;
								if (parser->len > 0)
								parser->buf[0] = '\0';
								parser->len = 0;
								{p = p - 1; } {p += 1; goto _out; }
							}
							
							*novo = parser->e;
							memset(&parser->e, 0, sizeof (parser->e));
							
							*(movies->last) = novo;
							*(movies->last = &novo->next) = NULL;
						}
						
#line 445 "parse2.c"
						
						break; 
					}
					case 9:  {
						{
#line 140 "parse2.rl"
							
							assert(parser->len > 0);
							if (movies->title)
							{
								code = CODE_ERROR_TITLE_REDEF;
								{p = p - 1; } {p += 1; goto _out; }
							}
							if (!(movies->title = strndup(parser->buf, parser->len)))
							{
								code = CODE_ENOMEM;
								{p = p - 1; } {p += 1; goto _out; }
							}
						}
						
#line 466 "parse2.c"
						
						break; 
					}
					case 10:  {
						{
#line 154 "parse2.rl"
							
							if (parser->len > 0)
							parser->buf[0] = '\0';
							parser->len = 0;
						}
						
#line 479 "parse2.c"
						
						break; 
					}
					case 11:  {
						{
#line 163 "parse2.rl"
							code = CODE_ERROR_NO_QUOTED; }
						
#line 488 "parse2.c"
						
						break; 
					}
					case 12:  {
						{
#line 173 "parse2.rl"
							parser->e.heading.level = (( (*( p)))) - '0'; }
						
#line 497 "parse2.c"
						
						break; 
					}
					case 13:  {
						{
#line 175 "parse2.rl"
							code = CODE_ERROR_TRAILING; }
						
#line 506 "parse2.c"
						
						break; 
					}
					case 14:  {
						{
#line 184 "parse2.rl"
							code = CODE_ERRO_LEVEL; }
						
#line 515 "parse2.c"
						
						break; 
					}
					case 15:  {
						{
#line 187 "parse2.rl"
							
							if (!(parser->e.heading.text = strndup(parser->buf, parser->len)))
							{
								code = CODE_ENOMEM;
								{p = p - 1; } {p += 1; goto _out; }
							}
						}
						
#line 530 "parse2.c"
						
						break; 
					}
					case 16:  {
						{
#line 206 "parse2.rl"
							code = CODE_ERROR_NO_SYMBOL_MOVIE; }
						
#line 539 "parse2.c"
						
						break; 
					}
					case 17:  {
						{
#line 207 "parse2.rl"
							code = CODE_ERROR_NO_AUT_MOVIE;    }
						
#line 548 "parse2.c"
						
						break; 
					}
					case 18:  {
						{
#line 208 "parse2.rl"
							code = CODE_ERROR_NO_YEAR;         }
						
#line 557 "parse2.c"
						
						break; 
					}
					case 19:  {
						{
#line 209 "parse2.rl"
							code = CODE_ERROR_NO_MOVIE_NAME;   }
						
#line 566 "parse2.c"
						
						break; 
					}
					case 20:  {
						{
#line 210 "parse2.rl"
							
							if (NULL == (parser->e.movie = movie_find_or_create(&movies->mov_first, parser->buf, parser->len)))
							{
								code = CODE_ENOMEM;
								{p = p - 1; } {p += 1; goto _out; }
							}
						}
						
#line 581 "parse2.c"
						
						break; 
					}
					case 21:  {
						{
#line 218 "parse2.rl"
							
							parser->e.movie->aut *= 10;
							parser->e.movie->aut += (( (*( p)))) - '0';
						}
						
#line 593 "parse2.c"
						
						break; 
					}
					case 22:  {
						{
#line 223 "parse2.rl"
							
							parser->e.movie->year *= 10;
							parser->e.movie->year += (( (*( p)))) - '0';
						}
						
#line 605 "parse2.c"
						
						break; 
					}
					case 23:  {
						{
#line 227 "parse2.rl"
							
							if (!(parser->e.movie->name = strndup(parser->buf, parser->len)))
							{
								code = CODE_ENOMEM;
								{p = p - 1; } {p += 1; goto _out; }
							}
						}
						
#line 620 "parse2.c"
						
						break; 
					}
					case 24:  {
						{
#line 234 "parse2.rl"
							
							if (parser->e.movie->defined)
							{
								code = CODE_ERROR_MOVIE_ALREADY_DEFINED;
								{p = p - 1; } {p += 1; goto _out; }
							}
						}
						
#line 635 "parse2.c"
						
						break; 
					}
					case 25:  {
						{
#line 241 "parse2.rl"
							parser->e.movie->defined = true; }
						
#line 644 "parse2.c"
						
						break; 
					}
				}
				_nacts -= 1;
				_acts += 1;
			}
			
		}
		
		if ( p == eof ) {
			if ( parser->cs >= 45 )
				goto _out;
		}
		else {
			if ( parser->cs != 0 ) {
				p += 1;
				goto _resume;
			}
		}
		_out: {}
	}
	
#line 265 "parse2.rl"
	
	
	return code;
}
