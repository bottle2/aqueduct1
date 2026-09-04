define(`XGH_WEB_TITLE',`List of music')dnl
ifelse(XGH_OUTPUT,`html',`dnl
`'divert(1)dnl
`'define(`XGH_AUTHOR',`  <p>$2</p>')dnl
dnl `'define(`MUSIC',`')dnl
`'define(`XGH_H',`  <h$1>$2</h$1>')dnl
`'define(`XGH_T',`  <p>XGH_T_$1:</p>')dnl
`'define(`XGH_T_ULTRA',`Ultra')dnl
`'define(`XGH_T_HIGH',`High testosterone')dnl
`'define(`XGH_T_MID',`Okay')dnl
`'define(`XGH_T_LOW',`Low testosterone')dnl
')dnl
dnl
define(`XGH_AUTHOR_2',`')dnl
define(`XGH_KILLED',`define(`XGH_KILL',`$1')dnl
`'XGH_KILL(`XGH_T')`'dnl
`'XGH_KILL(`XGH_AUTHOR')`'dnl
`'XGH_KILL(`XGH_AUTHOR_N')`'dnl
`'XGH_KILL(`XGH_AUTHOR_P')`'dnl
`'XGH_KILL(`XGH_AUTHOR_R')`'dnl
`'XGH_KILL(`MUSIC')`'dnl
`'XGH_KILL(`YTID')`'dnl
`'XGH_KILL(`XGH_H')`'dnl
`'undefine(`XGH_KILL')')dnl
XGH_KILLED(`ifdef(`$1',,`define(`$1',`dnl')')')dnl
dnl
XGH_H(`1',`List of music')
XGH_AUTHOR(`BRITNEY',`Britney Spears')
`'XGH_T(`MID')
`'MUSIC(`...Baby One More Time',`1999')
`'MUSIC(`Gimme More')
dnl
XGH_AUTHOR(`DUA_LIPA',`Dua Lipa')
`'XGH_T(`HIGH')
`'MUSIC(`Levitating Feat. DaBaby')
dnl
XGH_AUTHOR(`KATY_PERRY',`Katy Perry')
`'XGH_T(`ULTRA')
`'MUSIC(`Dark Horse',`2014',`YTID(`0KSOMA3QBU0',`-to 3:36')')
`'XGH_T(`HIGH')
`'MUSIC(`Roar',`2013')
`'XGH_T(`MID')
`'MUSIC(`Last Friday Night (T.G.I.F)',`2011')
`'MUSIC(`California Gurls ft. Snoop Dogg')
`'MUSIC(`Hot N Cold')
dnl
XGH_AUTHOR(`KESHA',`Ke$ha')
`'XGH_T(`HIGH')
`'MUSIC(`TiK ToK')
`'MUSIC(`We R Who We R')
`'XGH_T(`MID')
`'MUSIC(`Die Yound',`2012')
dnl
XGH_AUTHOR(`LADY_GAGA',`Lady Gaga')
`'XGH_T(`HIGH')
`'MUSIC(`Just Dance',`2008')
`'MUSIC(`Applause')
`'XGH_T(`MID')
`'MUSIC(`Monster')
`'XGH_T(`LOW')
`'MUSIC(`Alejandro')
dnl
XGH_AUTHOR(`MILEY_CYRUS',`Miley Cyrus')
`'XGH_T(`MID')
`'MUSIC(`Paty In The U.S.A.')
dnl
XGH_AUTHOR(`RIHANNA',`Rihanna')
`'XGH_T(`HIGH')
`'MUSIC(`We Found Love ft. Calvin Harris',`2011')
`'MUSIC(`Where Have You Been',`2001')
`'MUSIC(`Only Girl (In The World)')
`'MUSIC(`Umbrella ft. JAY-Z')
`'MUSIC(`SOS')
`'MUSIC(`Don@aq@t Stop The Music')
`'MUSIC(`Pon De Replay')
`'XGH_T(`LOW')
`'MUSIC(`S&M')
dnl
XGH_AUTHOR(`NELLY_FURTADO',`Nelly Furtado')
`'XGH_T(`HIGH')
`'MUSIC(`Promiscuous ft. Timbaland',`2009',`YTID(`0J3vgcE5i2o',`-ss 0:0:03.504 -to 0:03:58.655')')
`'XGH_T(`MID')
`'MUSIC(`Say It Right',`2006',`YTID(`6JnGBs88sL0',`-ss 0:0:10.677')')
dnl
XGH_AUTHOR(`SHAKIRA',`Shakira')
`'XGH_T(`HIGH')
`'MUSIC(`Whenever, Wherever',`2001',`YTID(`weRHyjj34ZE')')
`'MUSIC(`Ojos Así',`1998',`YTID(`5BzkbSq7pww')')
`'MUSIC(`Can@aq@t Remember to Forget You ft. Rihanna',`2014',`YTID(`o3mP3mJDL2k',`-to 0:03:24')')
dnl
XGH_AUTHOR(`TAYLOR_SWIFT',`Taylor Swift')
`'XGH_T(`ULTRA')
`'MUSIC(`Shake It Off',`2014',`YTID(`nfWlot6h_JM',`-to 0:03:47')')
dnl
XGH_AUTHOR(`THE_BLACK_EYED_PEAS',`The Black Eyed Peas')
`'XGH_T(`MID')
`'MUSIC(`Meet Me Halfway',`2009')
dnl
XGH_H(`2',`Miscellaneous')
dnl
ifelse(XGH_OUTPUT,`html',`dnl
`'define(`XGH_T',`  <h3>XGH_T_$1</h3>')dnl
')dnl
dnl
dnl
XGH_T(`HIGH')
dnl # TODO
XGH_AUTHOR(`MACKLEMORE_RYAN_LEWIS',`Macklemore & Ryan Lewis')
MUSIC(`Can@aq@t Hold Us feat. Ray Dalton',`2013',`YTID(`2zNSgSzhBfM',`-ss 0:0:07 -to 0:06:00')')
dnl
XGH_AUTHOR(`ONE_REPUBLIC',`One Republic')
MUSIC(`Counting Stars',`2014')
dnl
XGH_AUTHOR(`ZARA_LARSSON',`Zara Larsson')
MUSIC(`Lush Life',`2015')
dnl
dnl # XGH_AUTHOR_N(`PITBULL',`Pitbull',`P(`,', `R(`KESHA')')')
dnl # XGH_AUTHOR(`N',`PITBULL',`Pitbull',`P',`, ',`R',`KESHA')
dnl # XGH_AUTHOR(`NPR',`PITBULL',`Pitbull',`, ',`KESHA')
dnl # XGH_AUTHOR(`PITBULL',`Pitbull')`'XGH_(`, ')`'ADD_AUTHOR(`KESHA')
XGH_AUTHOR(`PITBULL',`Pitbull')
ADD_AUTHOR(`KESHA')
MUSIC(`Timber',`2013',`YTID(`hHUbLv4ThOo',`-ss 0:0:01 -to 0:3:22')')
dnl
XGH_AUTHOR(`NICKI_MINAJ',`Nicki Minaj')
MUSIC(`Starships')
dnl
XGH_AUTHOR(`DAVID_GUETTA',`David Guetta')
MUSIC(`Where Them Girls At')
dnl
XGH_AUTHOR(`CAPTAIN SPARKLEZ',`Captain Sparklez')
MUSIC(`Revenge')
MUSIC(`TNT')
dnl
XGH_T(`MID')
dnl
XGH_AUTHOR(`COLDPLAY',`Coldplay')
MUSIC(`Hymn For The Weekend',`2016')
dnl
XGH_AUTHOR(`JESSIE_J',`Jessie J')
MUSIC(`Price Tag ft. B.o.B',`2001')
dnl
XGH_AUTHOR(`DEMI_LOVATO',`Demi Lovato')
MUSIC(`Heart Attack',`2013')
dnl
XGH_AUTHOR(`AVA_MAX',`Ava Max')
MUSIC(`Sweet but Psycho',`2020')
dnl
XGH_AUTHOR(`CLEAN_BANDIT',`Clean Bandit')
MUSIC(`Rather Be ft. Jess Glynne')
dnl
XGH_AUTHOR(`CARLY_RAE_JEPSEN',`Carly Rae Jepsen')
MUSIC(`Call Me Maybe')
dnl
XGH_AUTHOR(`CASCADA',`Cascada')
MUSIC(`Everytime We Touch')
dnl
XGH_AUTHOR(`CHARLI XCX',`Charli XCX')
MUSIC(`Boom Clap')
dnl
XGH_T(`LOW')
dnl
XGH_AUTHOR(`NAUGHTY_BOY',`Naughty Boy')
MUSIC(`La la la ft Sam Smith',`2013',`YTID(`3O1_3zBUKM8',`-ss 0:0:12 -to 0:03:48')')
dnl
XGH_AUTHOR(`RAG_N_BONE',`Rag@aq@n@aq@Bone Man')
MUSIC(`Human',`2016')
dnl
XGH_AUTHOR(`ESTELLE',`Estelle')
MUSIC(`American Boy [Feat. Kanye West]')
dnl
XGH_AUTHOR(`POLLO',`Pollo')
MUSIC(`Vagalumes (part. Ivo Mozart)')
dnl # https://www.youtube.com/watch?v=XnBbjc5hmho
dnl # https://www.youtube.com/watch?v=oh2LWWORoiM
dnl # Sources:
dnl # https://www.youtube.com/watch?v=EKi9Kf_jPJU
dnl # https://www.youtube.com/watch?v=tRyXb85gFKw
dnl # https://www.youtube.com/watch?v=lK0sUU0K5SY
dnl # Right versions:
dnl # https://www.youtube.com/watch?v=kOCxHu_F5xo
dnl # https://www.youtube.com/watch?v=cPJNEGqf_jw
dnl # https://www.youtube.com/watch?v=aiEJgyGUwIk
dnl # https://www.youtube.com/watch?v=PFyMhNZB-lc
dnl # The three GOAT matrix musics:
dnl # https://www.youtube.com/watch?v=7iw4bynBYL0
dnl # https://www.youtube.com/watch?v=9GCjRXUICac
dnl # https://www.youtube.com/watch?v=C7-vezH4DPc
dnl # Tokyo Drift is cool: https://www.youtube.com/watch?v=iuJDhFRDx9M
dnl # Goku Drip: https://www.youtube.com/watch?v=gt52SaUnmNo
dnl # Sit: https://www.youtube.com/watch?v=A3auvksgVeA
dnl # O Rappa Lado B Lado A -- chilling
dnl # https://music.ishkur.com/
dnl # Powerful music:
dnl # Rukkus (aka Nightkilla aka Realistik (Stephen, Steve, Coub, Crouse)
dnl # Most viewed: https://rukkus.newgrounds.com/audio?sort=views
dnl # Highest score: https://rukkus.newgrounds.com/audio?sort=score
dnl # Least viewed:
dnl # https://www.newgrounds.com/search/conduct/audio?advanced=1&match=tdtu&user=Rukkus&before=2019-01-01&sort=views-asc
dnl # Lowest score:
dnl # https://www.newgrounds.com/search/conduct/audio?advanced=1&match=tdtu&user=Rukkus&before=2019-01-01&sort=score-desc
dnl # Xtrullor: https://www.newgrounds.com/playlist/293562/okay-xtrullor-music
dnl # KaixoMusic:
dnl # Beyond Paradise LP:
dnl # https://www.newgrounds.com/playlist/89855/beyond-paradise-lp
dnl # How it Began LP:
dnl # https://www.newgrounds.com/playlist/114017/how-it-began-lp
dnl # The Alpha Axiom EP:
dnl # https://www.newgrounds.com/playlist/114016/the-alpha-axiom-ep
dnl # Fragments LP:
dnl # https://www.newgrounds.com/playlist/330011/fragments-lp
dnl # High energy power victory music:
dnl # Creo Music:
dnl # https://creomusic.newgrounds.com/audio
dnl # cYsmix:
dnl # https://www.newgrounds.com/playlist/459852/okay-cysmix-music
dnl # Very very high energy music
dnl # https://www.youtube.com/watch?v=Gah8FnYSypk
dnl # https://f-777.newgrounds.com/audio?sort=views
dnl # Happy 2b Hardcore (albums 1 to 4 are good, 5 to 8 are trash)
dnl # Evil mood:
dnl # Periphery - Hail Stan IV
dnl # https://www.newgrounds.com/playlist/226666/mister-scoops
dnl # Intense chanting music for extra crunching, for overexherting,
dnl # work until exhaustion:
dnl # Static X - Wisconsin Death Trip
dnl # Music to cool down without losing work rhythm:
dnl # piri & tommy - froge.mp3
dnl # Comedy music, for "ironic" [detail more] mood:
dnl # Pink Guy - Pink Season:
dnl # https://www.youtube.com/watch?v=0c_mhrB7LlQ
dnl # Bonda II MC VV - BONDA 2
dnl # https://www.youtube.com/watch?v=fLELt1TueHw
dnl # Grumpy music, for "thwarted" feeling (shortlived):
dnl # Linkin Park - Hybrid Theory
dnl # Linkin Park - Meteora
dnl # When feeling nervous and dreary:
dnl # 50 Cent - Get Rich or Die Tryin'
dnl # Not classified:
dnl # Dido - No Angel
dnl # https://web.archive.org/web/20200509032233/http://www.technikal.co.uk/demo/technikal_promo_jan_07.zip
dnl # ^ Technikal - Promo
dnl # https://web.archive.org/web/20120722223115/http://www.technikal.co.uk/demo/Technikal_Promo_Mix_4.zip
dnl # ^ Technikal - Promo Mix 4 (some mid parts, which?)
dnl # Truckfighers - Gravity X
dnl # Wahnsinn - Fractal Severance
dnl # https://www.newgrounds.com/playlist/199842/fractal-severance
dnl # System of a Down [TODO]
dnl # Offspring - Greatest Hits
dnl # Disturbed - Indestructible
dnl # Deftones - Around the Fur
dnl # Calyx - No Turning Back
dnl # Charlie Brown Jr.
dnl # Authority Zero - Andiamo
dnl # Angra - [TODO] have to pick some
dnl # 50 cent - Get rich or die tryin'
dnl # What about the hardbass
dnl # Skipknot - Iowa
dnl # WaxTerK:
dnl # https://www.newgrounds.com/playlist/362100/okay-waxterk-music
dnl # Classical:
dnl # XGH_LIA(`https://www.youtube.com/user/TheWickedNorth',`TheWickedNorth - YouTube')
dnl # XGH_LIA(`https://www.youtube.com/user/neuIlaryRheinKlange',`neuIlaryRheinKlange - YouTube')
dnl # XGH_LIA(`https://www.youtube.com/user/IlaryRhineKlange/featured',`IlaryRhineKlange - YouTube')
dnl # XGH_LIA(`https://www.youtube.com/user/avrilfan2213',`avrilfan2213 - YouTube')
dnl # XGH_LIA(`https://open.spotify.com/playlist/0wbWiD8bxhhSFMLyNx8Mf8?si=WOwM4zGnQQmdFHTXNfl12g',`Japanese Vibes - Spotify')
dnl # Nerd music:
dnl # https://www.youtube.com/watch?v=_GM-9f2seLU
dnl # https://www.youtube.com/watch?v=b-Cr0EWwaTk
dnl # https://www.youtube.com/watch?v=SYRlTISvjww
dnl # https://www.youtube.com/watch?v=1S1fISh-pag
dnl # what about phonk?
dnl # whatever:
dnl # Hide Devious Methods
dnl # Alpha Omega - Realism / Visions
dnl # Dom & Roland - Back For The Future
dnl # Sugizo - Replicants
dnl # dead kennedys frankenchrist
dnl # StripE - Fighting for Freedom 
dnl # dream theater octavarium
dnl # Pantera - Vulgar Display Of Power 
dnl # GETO BOYS - STILL 
dnl # NWE Straight Outa Compton
dnl # Ndee Naldinho - O 5º Vigia 
dnl # RZO - O Trem 
dnl # Racionais
dnl # good monstercat:
dnl # https://www.youtube.com/watch?v=F70bYM_rirU
dnl # https://www.youtube.com/watch?v=WWNnBpuZMuI
dnl # https://www.youtube.com/watch?v=wqZ5iLOUOGA
dnl # https://www.youtube.com/watch?v=XN4WpPd-Ek0
dnl # https://www.youtube.com/watch?v=uVU_loTEeVk
dnl # Razorblade Romance
dnl # bobby brown goes down
dnl # Jerry Lee Lewis
dnl # Queens of the Stone Age - Songs for the Dead
dnl # The Mars Volta - De-Loused in the Comatorium
dnl # Marilyn Manson - Antichrist Superstar
dnl # Slayer - Reign in Blood
dnl # Afrob - Rolle mit Hip-Hop (German Rap)
dnl # Aphex Twin - Drukqs
dnl # Bajofondo
dnl # Boards of Canada
dnl # Lift Your Skinny Fists Like Antennas to Heaven
dnl # https://jaypedia.xyz/2023_prog
dnl # https://www.youtube.com/watch?v=okHz7CE8wp0
dnl # https://www.youtube.com/watch?v=ybJoNEhi7rQ
dnl # What
dnl # https://music.youtube.com/watch?v=ulPDzcTwBBI
dnl # Turk rap?
dnl # https://www.youtube.com/watch?v=z9KfvYVSfHY
dnl # Farazi V Kayra - Sarhoş Palavraları ve Nahoş Nidalar ( Full Albüm )
dnl # Farazi v Kayra - Sarhoş Palavraları ve İbretlik Hikayeler (Full Albüm) 
dnl # https://www.youtube.com/watch?v=gwSv7t1xa2g
dnl # What?
dnl # https://www.youtube.com/watch?v=Qv-7t5kljIU&list=PL2g0zFo9TJOC9LKjb8NCJZQLFMFg52YU9&index=3
dnl # https://www.youtube.com/watch?v=gSXMQ-3PZ6g&list=PL2g0zFo9TJOC9LKjb8NCJZQLFMFg52YU9&index=2
dnl # https://www.urbandictionary.com/define.php?term=jump-up
dnl # https://www.youtube.com/watch?v=lP2xC5eC2xM
dnl # God Rest Ye Deadly Gentlemen 
dnl # https://www.youtube.com/watch?v=3qnrewFcnQs
dnl # https://www.youtube.com/watch?v=PBumWpOOobw
dnl # https://www.youtube.com/watch?v=u0n4eMGXAyk
dnl # https://www.youtube.com/watch?v=RkkGVgOqPuM
dnl # https://www.youtube.com/watch?v=eR-aDgaUPG0
dnl # https://www.youtube.com/watch?v=N4Db0oYKXvw
XGH_KILLED(`undefine(`$1')')dnl
undefine(`XGH_KILLED')dnl
