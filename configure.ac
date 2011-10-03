# check for one particular file of the sources
AC_INIT([ocaml-soundtouch],[0.1.7],[savonet-users@lists.sourceforge.net])

VERSION=$PACKAGE_VERSION
AC_MSG_RESULT([configuring $PACKAGE_STRING])

AC_BASE_CHECKS()

AC_PROG_CXX()
# Check for libsoundtouch
PKG_PROG_PKG_CONFIG()
#PKG_CHECK_MODULES(SOUNDTOUCH,libSoundTouch,,[AC_MSG_ERROR(libsoundtouch not found.)])
# PKG_CHECK_MODULES loses when you need --libs-only-[lL]
SOUNDTOUCH_PKG="soundtouch"
AC_MSG_CHECKING([soundtouch library and headers])
if ! $PKG_CONFIG --exists $SOUNDTOUCH_PKG; then
  if ! $PKG_CONFIG --exists libSoundTouch; then
    if ! $PKG_CONFIG --exists soundtouch-1.0; then
      AC_MSG_ERROR([soundtouch not found])
    else
      SOUNDTOUCH_PKG="soundtouch-1.0"
    fi
  else
    # This is debian specific, added for backward compatibility
    # but should be removed when not needed anymore..
    SOUNDTOUCH_PKG="libSoundTouch"
  fi
fi
AC_MSG_RESULT([ok])
CFLAGS="$CFLAGS `$PKG_CONFIG --cflags $SOUNDTOUCH_PKG`"
CPPFLAGS="$CPPFLAGS `$PKG_CONFIG --cflags $SOUNDTOUCH_PKG`"
LIBS="$LIBS `$PKG_CONFIG --libs-only-l $SOUNDTOUCH_PKG` -lstdc++"
LDFLAGS="$LDFLAGS `$PKG_CONFIG --libs-only-L $SOUNDTOUCH_PKG`"

# Check if we need to add -lBPM..
AC_MSG_CHECKING([if -lBPM is needed])
AC_LANG_PUSH(C++)
AC_LINK_IFELSE(
  [AC_LANG_PROGRAM([[#include <soundtouch/BPMDetect.h>
                     using namespace soundtouch;]],
    [[BPMDetect *bpm = new BPMDetect(2, 44100);]])],
  [BPMTEST=1],
  [BPMTEST=0])
# If false, run again with -lBPM
if test "x$BPMTEST" != "x1"; then
  LIBS="$LIBS -lBPM"
  AC_LINK_IFELSE(
    [AC_LANG_PROGRAM([[#include <soundtouch/BPMDetect.h>
                       using namespace soundtouch;]],
      [[BPMDetect *bpm = new BPMDetect(2, 44100);]])],
    [AC_MSG_RESULT([yes])],
    [AC_MSG_ERROR([Cannot find BPMDetect..])])
else
  AC_MSG_RESULT([no])
fi

# substitutions to perform
AC_SUBST(VERSION)
AC_SUBST(INC)
AC_SUBST(LIBS)
AC_SUBST(LDFLAGS)
AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)

# Finally create the Makefile and samples
AC_CONFIG_FILES([Makefile],[chmod a-w Makefile])
AC_CONFIG_FILES([src/META])
AC_CONFIG_FILES([src/Makefile])
AC_OUTPUT
