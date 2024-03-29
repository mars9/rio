#!/bin/sh

[ -f $PLAN9/config ] && . $PLAN9/config

if [ "x$X11" = "x" ]; then 
	if [ -d /usr/X11R6 ]; then
		X11=/usr/X11R6
	elif [ -d /usr/local/X11R6 ]; then
		X11=/usr/local/X11R6
	elif [ -d /usr/X ]; then
		X11=/usr/X
	elif [ -d /usr/openwin ]; then	# for Sun
		X11=/usr/openwin
	elif [ -d /usr/include/X11 ]; then
		X11=/usr
	elif [ -d /usr/local/include/X11 ]; then
		X11=/usr/local
	else
		X11=noX11dir
	fi
fi

if [ "x$WSYSTYPE" = "x" ]; then
	if [ "x`uname`" = "xDarwin" ]; then
		if sw_vers | grep 'ProductVersion:	10\.[0-5]\.' >/dev/null; then
			WSYSTYPE=osx
		else
			#echo 1>&2 'WARNING: OS X Lion is not working.  Copy binaries from a Snow Leopard system.'
			WSYSTYPE=osx-cocoa
		fi
	elif [ -d "$X11" ]; then
		WSYSTYPE=x11
	else
		WSYSTYPE=nowsys
	fi
fi

if [ "x$WSYSTYPE" = "xx11" -a "x$X11H" = "x" ]; then
	if [ -d "$X11/include" ]; then
		X11H="-I$X11/include"
		if [ -d "$X11/include/freetype2" ]; then
			X11H=$X11H" -I$X11/include/freetype2"
			LDFLAGS="-lXft"
		fi
	else
		X11H=""
	fi
fi
	
echo 'WSYSTYPE='$WSYSTYPE
echo 'X11='$X11
echo 'X11H='$X11H

if [ $WSYSTYPE = x11 ]; then
	echo 'CFLAGS=$CFLAGS '$X11H
	echo 'LDFLAGS='$LDFLAGS
	echo 'HFILES=$HFILES $XHFILES'
	XO=`ls x11-*.c 2>/dev/null | sed 's/\.c$/.o/'`
	echo 'WSYSOFILES=$WSYSOFILES '$XO
elif [ $WSYSTYPE = osx ]; then
	if [ -d /System/Library/PrivateFrameworks/MultitouchSupport.framework ]; then
		echo 'CFLAGS=$CFLAGS -DMULTITOUCH'
		echo 'LDFLAGS=$LDFLAGS -F/System/Library/PrivateFrameworks'
	fi
	echo 'WSYSOFILES=$WSYSOFILES osx-screen-carbon-objc.o osx-draw.o osx-srv.o'
	echo 'MACARGV=macargv.o'
elif [ $WSYSTYPE = osx-cocoa ]; then
	echo 'WSYSOFILES=$WSYSOFILES osx-draw.o cocoa-screen-objc.o cocoa-srv.o cocoa-thread.o'
	echo 'MACARGV=macargv-objc.o'
elif [ $WSYSTYPE = nowsys ]; then
	echo 'WSYSOFILES=nowsys.o'
fi
