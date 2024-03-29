<$PLAN9/src/mkhdr
<|sh mkwsysrules.sh	# for X11

RIOFILES=\
	client.$O\
	color.$O\
	cursor.$O\
	error.$O\
	event.$O\
	grab.$O\
	key.$O\
	main.$O\
	manage.$O\
	menu.$O\

CFLAGS=$CFLAGS
LDFLAGS=$LDFLAGS
HFILES=dat.h fns.h

TARG=rio xshove clock

# need to add lib64 when it exists (on x86-64), but
# Darwin complains about the nonexistant directory
# Bug in mk? "$L64 -lXext" gobbles the space, so 
# add trailing slash.
L64=`[ -d $X11/lib64 ] && echo 64; echo`
LDFLAGS=-L$X11/lib$L64/ $LDFLAGS -lXext -lX11

<|sh mkriorules.sh

$O.rio: $RIOFILES

CFLAGS=$CFLAGS -DSHAPE -DDEBUG_EV -DDEBUG

$O.xevents: xevents.$O printevent.$O
	$LD -o $target $prereq $LDFLAGS

xevents.$O printevent.$O: printevent.h

error.$O: showevent/ShowEvent.c

$O.xshove: xshove.$O
	$LD -o $O.xshove xshove.$O -lX11

$O.clock: clock.$O
	$LD -o $O.clock clock.$O -lX11
