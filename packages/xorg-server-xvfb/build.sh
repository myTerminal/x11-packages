TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X virtual framebuffer"
TERMUX_PKG_VERSION=1.20.1
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=59c99fe86fe75b8164c6567bfc6e982aecc2e4a51e6fbac1b842d5d00549e918

TERMUX_PKG_DEPENDS="libandroid-shmem, libdrm, libpixman, libx11, libxau, libxfont2, libxinerama, libxkbfile, libxshmfence, mesa, openssl, xkeyboard-config, xorg-xkbcomp"
TERMUX_PKG_CONFLICTS="xorg-xvfb"
TERMUX_PKG_REPLACES="xorg-xvfb"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-composite
--enable-mitshm
--enable-xres
--enable-record
--enable-xv
--enable-xvmc
--enable-dga
--enable-screensaver
--enable-xdmcp
--enable-glx
--enable-dri
--enable-dri2
--enable-dri3
--enable-present
--enable-xinerama
--enable-xf86vidmode
--enable-xace
--enable-xcsecurity
--enable-dbe
--enable-xf86bigfont
--disable-xfree86-utils
--disable-vgahw
--disable-vbe
--disable-int10-module
--enable-libdrm
--disable-pciaccess
--disable-linux-acpi
--disable-linux-apm
--disable-xorg
--disable-dmx
--enable-xvfb
--disable-xnest
--disable-xwayland
--disable-xwin
--disable-kdrive
--disable-xephyr
--disable-libunwind
--enable-xshmfence
--enable-ipv6
--with-sha1=libcrypto
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
--with-xkb-path=${TERMUX_PREFIX}/share/X11/xkb
LIBS=-landroid-shmem"

termux_step_pre_configure () {
    CFLAGS+=" -DFNDELAY=O_NDELAY"
    CPPFLAGS+=" -I${TERMUX_PREFIX}/include/libdrm"

    if [ -n "${TERMUX_DEBUG}" ]; then
        TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-debug"
    fi
}

termux_step_post_make_install () {
    rm -f "${TERMUX_PREFIX}/usr/share/X11/xkb/compiled"
}

## The following is required for package 'tigervnc'.
if [ "${#}" -eq 1 ] && [ "${1}" == "xorg_server_flags" ]; then
        echo ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
        return
fi