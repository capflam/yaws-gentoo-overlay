# $Header: $

EAPI="5"

inherit eutils autotools

DESCRIPTION="Yaws is a high performance HTTP 1.1 web server."
HOMEPAGE="http://yaws.hyber.org/"
SRC_URI="http://yaws.hyber.org/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64"
IUSE=""

DEPEND="dev-lang/erlang sys-devel/libtool sys-libs/pam"
RDEPEND="dev-lang/erlang sys-libs/pam"

PROVIDE="virtual/httpd-basic virtual/httpd-cgi"

src_prepare() {
	eautoreconf -fi
}

src_configure() {
	ERLANG_INSTALL_LIB_DIR=/usr/$(get_libdir)/erlang/lib	\
	logdir=/var/log/yaws	 				\
	econf
}

src_install() {
	emake TMPDIR=/tmp DESTDIR=${D} install || edie
	rmdir ${D}var/lib/log/yaws
	rmdir ${D}var/lib/log
	rm -f ${D}usr/$(get_libdir)/yaws
	# We need to keep these directories so that the example yaws.conf works
	# properly
	keepdir /var/log/yaws
	keepdir /usr/$(get_libdir)/erlang/lib/${P}/examples/ebin
	keepdir /usr/$(get_libdir)/erlang/lib/${P}/examples/include
	dodoc LICENSE
}

pkg_postinst() {
	einfo "An example YAWS configuration has been setup to run on"
	einfo "Please edit /etc/yaws/yaws.conf to suit your needs."

	if test -d /usr/$(get_libdir)/yaws; then
		backupdir="/usr/$(get_libdir)/yaws.backup"
		einfo "backup old yaws directory into ${backupdir}"
		mv /usr/$(get_libdir)/yaws ${backupdir}
	fi
	rm -f /usr/$(get_libdir)/yaws
	ln -s /usr/$(get_libdir)/erlang/lib/${P} /usr/$(get_libdir)/yaws
}

pkg_postrm() {
	rm -f /usr/$(get_libdir)/yaws
}
