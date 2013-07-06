#!/bin/bash
#this file is version $Revision: 527 $

#follow http://www.debian.org/doc/maint-guide/ch-start.en.html


#$Date: 2008-09-01 08:11:43 +0200 (mån, 01 sep 2008) $
#$Rev: 527 $
#$Author: pauls $
#$Id: create_package.sh 527 2008-09-01 06:11:43Z pauls $


#let the build directory be some junk

builddir=$HOME/tmp/debianize_rdfind
sourcedir=$HOME/code/eget/all/rdfind
sourcename=rdfind-1.2.2+
targz=.tar.gz
if [ -d $builddir ]; then
#echo "dont dare to rm..."
 rm -rf $builddir/rdfind*
fi

mkdir  -p $builddir

cp $sourcedir/$sourcename$targz $builddir
pushd $builddir
tar xvzf $sourcename$targz
cd $sourcename
dh_make -e rdfind@paulsundvall.net -f ../$sourcename$targz
#(answer s, single binary)
#emacs debian/control
cp $sourcedir/debianpackage/{control,copyright,changelog} debian/
cp $sourcedir/rdfind.1 debian/

#leave debian/rules unchanged
rm debian/README.Debian
#debian/conffiles.ex was missing! should be deleted anyway...
rm debian/*.ex
#rm debian/cron.d.ex
#changed debian/dirs to contain only usr/bin
echo "usr/bin"> debian/dirs
#debian/docs unchanged
rm debian/emacsen-*
# rm debian/init.d.ex

#emacs debian/menu.ex
echo '?package(rdfind):needs="text" section="Apps/Util"\
         title="rdfind" command="/usr/bin/rdfind"'>debian/menu
rm debian/rdfind.doc-base.EX
dpkg-buildpackage -rfakeroot -k0x509CCB46

echo "now running linda to check that the package is ok"
linda -i ../*.changes

echo "now running lintian to check that the package is ok"
lintian -i ../*.changes

popd

echo "done! your files should be in $builddir, if everything went well"
