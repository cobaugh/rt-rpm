# Copyright (C) 1998, 1999, 2000, 2001, 2003 Free Software Foundation, Inc.
#
# This file is part of GnuPG.
#
# GnuPG is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# GnuPG is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
# Process this file with automake to create Makefile.in

GPG_IMPORT  = ../g10/gpg --homedir . --quiet --yes --no-permission-warning --import

TESTS = version.test mds.test \
	decrypt.test decrypt-dsa.test \
	sigs.test sigs-dsa.test \
	encrypt.test encrypt-dsa.test  \
	seat.test clearsig.test encryptp.test detach.test \
	armsigs.test armencrypt.test armencryptp.test \
	signencrypt.test signencrypt-dsa.test \
	armsignencrypt.test armdetach.test \
	armdetachm.test detachm.test genkey1024.test \
	conventional.test conventional-mdc.test \
	multisig.test verify.test armor.test

# Force sequential run of tests as in the good old times
mds.log:               version.log
decrypt.log:           mds.log
decrypt-dsa.log:       decrypt.log
sigs.log:	       decrypt-dsa.log
sigs-dsa.log:	       sigs.log
encrypt.log:	       sigs-dsa.log
encrypt-dsa.log:       encrypt.log
seat.log:	       encrypt-dsa.log
clearsig.log:	       seat.log
encryptp.log:	       clearsig.log
detach.log: 	       encryptp.log
armsigs.log:	       detach.log
armencrypt.log:	       armsigs.log
armencryptp.log:       armencrypt.log
signencrypt.log:       armencryptp.log
signencrypt-dsa.log:   signencrypt.log
armsignencrypt.log:    signencrypt-dsa.log
armdetach.log:	       armsignencrypt.log
armdetachm.log:	       armdetach.log
detachm.log:	       armdetachm.log
genkey1024.log:	       detachm.log
conventional.log:      genkey1024.log
conventional-mdc.log:  conventional.log
multisig.log:	       conventional-mdc.log
verify.log:            multisig.log
armor.log:             verify.log



TEST_FILES = pubring.asc secring.asc plain-1o.asc plain-2o.asc plain-3o.asc \
	     plain-1.asc plain-2.asc plain-3.asc plain-1-pgp.asc \
	     pubring.pkr.asc secring.skr.asc secdemo.asc pubdemo.asc options

DATA_FILES = data-500 data-9000 data-32000 data-80000 plain-large

EXTRA_DIST = defs.inc $(TESTS) $(TEST_FILES) \
	     mkdemodirs signdemokey
CLEANFILES = defs-config.inc x y yy z out err  $(DATA_FILES) \
	     plain-1 plain-2 plain-3 trustdb.gpg *.lock .\#lk* \
	     *.test.log gpg_dearmor gpg.conf \
	     pubring.gpg secring.gpg pubring.pkr secring.skr
DISTCLEANFILES = pubring.gpg~ random_seed


all-local: defs-config.inc

distclean-local:
	$(srcdir)/mkdemodirs --clean

defs-config.inc: ./pubring.gpg ./secring.gpg ./plain-1 ./plain-2 ./plain-3 \
		./pubring.pkr ./secring.skr ./gpg_dearmor $(DATA_FILES)
	 $(GPG_IMPORT) $(srcdir)/pubdemo.asc
	 echo '# Do not edit - created by the Makefile.      -*- sh -*-' \
               > defs-config.inc
if ENABLE_SELINUX_HACKS
	 echo enable_selinux_hacks=yes >> defs-config.inc
else
	 echo enable_selinux_hacks=no >> defs-config.inc
endif


./gpg_dearmor:
	echo '#!/bin/sh' >./gpg_dearmor
	echo "../g10/gpg --no-options --no-greeting \
             --no-secmem-warning --batch --dearmor" >>./gpg_dearmor
	chmod 755 ./gpg_dearmor

./pubring.gpg: $(srcdir)/pubring.asc $(srcdir)/pubdemo.asc ./gpg_dearmor
	./gpg_dearmor > ./pubring.gpg < $(srcdir)/pubring.asc

./secring.gpg: $(srcdir)/secring.asc ./gpg_dearmor
	./gpg_dearmor > ./secring.gpg < $(srcdir)/secring.asc

./pubring.pkr: $(srcdir)/pubring.pkr.asc ./gpg_dearmor
	./gpg_dearmor > ./pubring.pkr < $(srcdir)/pubring.pkr.asc

./secring.skr: $(srcdir)/secring.skr.asc ./gpg_dearmor
	./gpg_dearmor > ./secring.skr < $(srcdir)/secring.skr.asc

./plain-1: $(srcdir)/plain-1o.asc ./gpg_dearmor
	./gpg_dearmor > ./plain-1 < $(srcdir)/plain-1o.asc

./plain-2: $(srcdir)/plain-2o.asc ./gpg_dearmor
	./gpg_dearmor > ./plain-2 < $(srcdir)/plain-2o.asc

./plain-3: $(srcdir)/plain-3o.asc ./gpg_dearmor
	./gpg_dearmor > ./plain-3 < $(srcdir)/plain-3o.asc


data-500:
	../tools/mk-tdata   500  >data-500
data-9000:
	../tools/mk-tdata  9000  >data-9000
data-32000:
	../tools/mk-tdata 32000  >data-32000
data-80000:
	../tools/mk-tdata 80000  >data-80000
plain-large:
	cat $(srcdir)/../doc/HACKING \
	    $(srcdir)/../doc/DETAILS \
	    $(srcdir)/../doc/FAQ	 >plain-large
