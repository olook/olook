
SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = /Users/rafa/.rvm/rubies/ruby-1.9.2-p290/include/ruby-1.9.1
hdrdir = /Users/rafa/.rvm/rubies/ruby-1.9.2-p290/include/ruby-1.9.1
arch_hdrdir = /Users/rafa/.rvm/rubies/ruby-1.9.2-p290/include/ruby-1.9.1/$(arch)
VPATH = $(srcdir):$(arch_hdrdir)/ruby:$(hdrdir)/ruby
prefix = $(DESTDIR)/Users/rafa/.rvm/rubies/ruby-1.9.2-p290
rubylibprefix = $(libdir)/$(RUBY_BASE_NAME)
exec_prefix = $(prefix)
vendorhdrdir = $(rubyhdrdir)/vendor_ruby
sitehdrdir = $(rubyhdrdir)/site_ruby
rubyhdrdir = $(includedir)/$(RUBY_BASE_NAME)-$(ruby_version)
vendordir = $(rubylibprefix)/vendor_ruby
sitedir = $(rubylibprefix)/site_ruby
ridir = $(datarootdir)/$(RI_BASE_NAME)
mandir = $(datarootdir)/man
localedir = $(datarootdir)/locale
libdir = $(exec_prefix)/lib
psdir = $(docdir)
pdfdir = $(docdir)
dvidir = $(docdir)
htmldir = $(docdir)
infodir = $(datarootdir)/info
docdir = $(datarootdir)/doc/$(PACKAGE)
oldincludedir = $(DESTDIR)/usr/include
includedir = $(prefix)/include
localstatedir = $(prefix)/var
sharedstatedir = $(prefix)/com
sysconfdir = $(prefix)/etc
datadir = $(datarootdir)
datarootdir = $(prefix)/share
libexecdir = $(exec_prefix)/libexec
sbindir = $(exec_prefix)/sbin
bindir = $(exec_prefix)/bin
rubylibdir = $(rubylibprefix)/$(ruby_version)
archdir = $(rubylibdir)/$(arch)
sitelibdir = $(sitedir)/$(ruby_version)
sitearchdir = $(sitelibdir)/$(sitearch)
vendorlibdir = $(vendordir)/$(ruby_version)
vendorarchdir = $(vendorlibdir)/$(sitearch)

CC = /usr/local/bin/gcc-4.2
CXX = g++
LIBRUBY = $(LIBRUBY_SO)
LIBRUBY_A = lib$(RUBY_SO_NAME)-static.a
LIBRUBYARG_SHARED = -l$(RUBY_SO_NAME)
LIBRUBYARG_STATIC = -l$(RUBY_SO_NAME)-static
OUTFLAG = -o 
COUTFLAG = -o 

RUBY_EXTCONF_H = 
cflags   =  $(optflags) $(debugflags) $(warnflags)
optflags = -O3
debugflags = -ggdb
warnflags = -Wextra -Wno-unused-parameter -Wno-parentheses -Wpointer-arith -Wwrite-strings -Wno-missing-field-initializers -Wshorten-64-to-32 -Wno-long-long
CFLAGS   = -fno-common -I/Users/rafa/.rvm/usr/include -fno-common -pipe 
INCFLAGS = -I. -I$(arch_hdrdir) -I$(hdrdir)/ruby/backward -I$(hdrdir) -I$(srcdir)
DEFS     = 
CPPFLAGS = -DHAVE_ZLIB_H -DHAVE_FSEEKO -DHAVE_FTELLO -DHAVE_MKSTEMP -D_XOPEN_SOURCE -D_DARWIN_C_SOURCE $(DEFS) $(cppflags)
CXXFLAGS = $(CFLAGS) $(cxxflags)
ldflags  = -L. -L/Users/rafa/.rvm/usr/lib
dldflags = -Wl,-undefined,dynamic_lookup -Wl,-multiply_defined,suppress -Wl,-flat_namespace
ARCH_FLAG = 
DLDFLAGS = $(ldflags) $(dldflags)
LDSHARED = $(CC) -dynamic -bundle
LDSHAREDXX = $(CXX) -dynamic -bundle
AR = ar
EXEEXT = 

RUBY_BASE_NAME = ruby
RUBY_INSTALL_NAME = ruby
RUBY_SO_NAME = ruby.1.9.1
arch = x86_64-darwin11.4.2
sitearch = $(arch)
ruby_version = 1.9.1
ruby = /Users/rafa/.rvm/rubies/ruby-1.9.2-p290/bin/ruby
RUBY = $(ruby)
RM = rm -f
RM_RF = $(RUBY) -run -e rm -- -rf
RMDIRS = $(RUBY) -run -e rmdir -- -p
MAKEDIRS = mkdir -p
INSTALL = /usr/bin/install -c
INSTALL_PROG = $(INSTALL) -m 0755
INSTALL_DATA = $(INSTALL) -m 644
COPY = cp

#### End of system configuration section. ####

preload = 

libpath = . $(libdir)
LIBPATH =  -L. -L$(libdir)
DEFFILE = 

CLEANFILES = mkmf.log
DISTCLEANFILES = 
DISTCLEANDIRS = 

extout = 
extout_prefix = 
target_prefix = 
LOCAL_LIBS = 
LIBS = $(LIBRUBYARG_SHARED) -lz  -lpthread -ldl -lobjc 
SRCS = mkstemp.c tmpfile.c zip_add.c zip_add_dir.c zip_close.c zip_crypt.c zip_delete.c zip_dirent.c zip_entry_free.c zip_entry_new.c zip_err_str.c zip_error.c zip_error_clear.c zip_error_get.c zip_error_get_sys_type.c zip_error_strerror.c zip_error_to_str.c zip_fclose.c zip_file_error_clear.c zip_file_error_get.c zip_file_get_offset.c zip_file_strerror.c zip_fopen.c zip_fopen_index.c zip_fread.c zip_free.c zip_get_archive_comment.c zip_get_file_comment.c zip_get_name.c zip_get_num_files.c zip_memdup.c zip_name_locate.c zip_new.c zip_open.c zip_rename.c zip_replace.c zip_set_archive_comment.c zip_set_file_comment.c zip_set_name.c zip_source_buffer.c zip_source_file.c zip_source_filep.c zip_source_free.c zip_source_function.c zip_source_zip.c zip_stat.c zip_stat_index.c zip_stat_init.c zip_strerror.c zip_unchange.c zip_unchange_all.c zip_unchange_archive.c zip_unchange_data.c zipruby.c zipruby_archive.c zipruby_error.c zipruby_file.c zipruby_stat.c zipruby_zip.c zipruby_zip_source_io.c zipruby_zip_source_proc.c
OBJS = mkstemp.o tmpfile.o zip_add.o zip_add_dir.o zip_close.o zip_crypt.o zip_delete.o zip_dirent.o zip_entry_free.o zip_entry_new.o zip_err_str.o zip_error.o zip_error_clear.o zip_error_get.o zip_error_get_sys_type.o zip_error_strerror.o zip_error_to_str.o zip_fclose.o zip_file_error_clear.o zip_file_error_get.o zip_file_get_offset.o zip_file_strerror.o zip_fopen.o zip_fopen_index.o zip_fread.o zip_free.o zip_get_archive_comment.o zip_get_file_comment.o zip_get_name.o zip_get_num_files.o zip_memdup.o zip_name_locate.o zip_new.o zip_open.o zip_rename.o zip_replace.o zip_set_archive_comment.o zip_set_file_comment.o zip_set_name.o zip_source_buffer.o zip_source_file.o zip_source_filep.o zip_source_free.o zip_source_function.o zip_source_zip.o zip_stat.o zip_stat_index.o zip_stat_init.o zip_strerror.o zip_unchange.o zip_unchange_all.o zip_unchange_archive.o zip_unchange_data.o zipruby.o zipruby_archive.o zipruby_error.o zipruby_file.o zipruby_stat.o zipruby_zip.o zipruby_zip_source_io.o zipruby_zip_source_proc.o
TARGET = zipruby
DLLIB = $(TARGET).bundle
EXTSTATIC = 
STATIC_LIB = 

BINDIR        = $(bindir)
RUBYCOMMONDIR = $(sitedir)$(target_prefix)
RUBYLIBDIR = /Users/rafa/olook/olook/vendor/bundle/ruby/1.9.1/gems/zipruby-0.3.6/lib$(target_prefix)
RUBYARCHDIR = /Users/rafa/olook/olook/vendor/bundle/ruby/1.9.1/gems/zipruby-0.3.6/lib$(target_prefix)
HDRDIR        = $(rubyhdrdir)/ruby$(target_prefix)
ARCHHDRDIR    = $(rubyhdrdir)/$(arch)/ruby$(target_prefix)

TARGET_SO     = $(DLLIB)
CLEANLIBS     = $(TARGET).bundle 
CLEANOBJS     = *.o  *.bak

all:    $(DLLIB)
static: $(STATIC_LIB)
.PHONY: all install static install-so install-rb
.PHONY: clean clean-so clean-rb

clean-rb-default::
clean-rb::
clean-so::
clean: clean-so clean-rb-default clean-rb
		@-$(RM) $(CLEANLIBS) $(CLEANOBJS) $(CLEANFILES)

distclean-rb-default::
distclean-rb::
distclean-so::
distclean: clean distclean-so distclean-rb-default distclean-rb
		@-$(RM) Makefile $(RUBY_EXTCONF_H) conftest.* mkmf.log
		@-$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)
		@-$(RMDIRS) $(DISTCLEANDIRS)

realclean: distclean
install: install-so install-rb

install-so: $(RUBYARCHDIR)
install-so: $(RUBYARCHDIR)/$(DLLIB)
$(RUBYARCHDIR)/$(DLLIB): $(DLLIB)
	@-$(MAKEDIRS) $(@D)
	$(INSTALL_PROG) $(DLLIB) $(@D)
install-rb: pre-install-rb install-rb-default
install-rb-default: pre-install-rb-default
pre-install-rb: Makefile
pre-install-rb-default: Makefile
$(RUBYARCHDIR):
	$(MAKEDIRS) $@

site-install: site-install-so site-install-rb
site-install-so: install-so
site-install-rb: install-rb

.SUFFIXES: .c .m .cc .cxx .cpp .C .o

.cc.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.cxx.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.cpp.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.C.o:
	$(CXX) $(INCFLAGS) $(CPPFLAGS) $(CXXFLAGS) $(COUTFLAG)$@ -c $<

.c.o:
	$(CC) $(INCFLAGS) $(CPPFLAGS) $(CFLAGS) $(COUTFLAG)$@ -c $<

$(DLLIB): $(OBJS) Makefile
	@-$(RM) $(@)
	$(LDSHARED) -o $@ $(OBJS) $(LIBPATH) $(DLDFLAGS) $(LOCAL_LIBS) $(LIBS)



$(OBJS): $(hdrdir)/ruby.h $(hdrdir)/ruby/defines.h $(arch_hdrdir)/ruby/config.h
