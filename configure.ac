AC_INIT(seshat, 25.6)
AM_INIT_AUTOMAKE([foreign tar-ustar])
AM_PATH_PYTHON([3.9])
AC_CONFIG_FILES([
  guix.scm
  Makefile
  src/Makefile
  pyproject.toml
  rpmbuild/SPECS/seshat.spec
])

dnl Check for presence of 'typst'.
dnl ---------------------------------------------------------------------------
AC_CHECK_PROG(TYPST, typst, typst)

if test "x$TYPST" = "x"; then
  AC_MSG_WARN([Unable to create the user manual.])
else
  AC_CONFIG_FILES([doc/Makefile doc/config.typ src/seshat/config.py])
fi

AM_CONDITIONAL([HAVE_TYPST], [test -n "$TYPST"])

dnl Check for the presence of 'docker' or 'podman'.
dnl ---------------------------------------------------------------------------
AC_CHECK_PROG(DOCKER, docker, docker)
if test "x$DOCKER" = "x"; then
  AC_CHECK_PROG(DOCKER, podman, podman)
fi

AM_CONDITIONAL([HAVE_DOCKER], [test -n "$DOCKER"])

dnl Check for the Python 'build' module.
dnl ---------------------------------------------------------------------------
if test "x$PYTHON" != "x"; then
   $PYTHON -m build --version > /dev/null 2> /dev/null
   if test $? -ne 0; then
      AC_MSG_WARN([Unable to build tarballs due to missing Python 'build' module.])
   fi
fi

dnl Package-specific configurable options
dnl ---------------------------------------------------------------------------

AC_ARG_VAR(BASE_URL, [The URL on which the instance will run.  This is only
                      used to align the documentation.])

dnl Default value for BASE_URL (use without "/" at the end)
: "${BASE_URL=https://demo.seshat.software/}"

AC_ARG_VAR(GIT_URL, [The URL of the Git repository for the code of this
                     instance.  This is only used to align the documentation.])

dnl Default value for GIT_URL
: "${GIT_URL=https://codeberg.org/seshat/seshat}"

dnl Check for presence of 'git'.
dnl ---------------------------------------------------------------------------
AC_CHECK_PROG(GIT, git, git)
AC_OUTPUT
