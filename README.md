Gtk-Fortran for Windows
=======================

Introduction
------------

This branch is designed to be easily buildable on Win32 systems using MinGW and CMake.  Specifically, it addresses some issues with the master branch that can cause the build to fail on MinGW.  Most notably, the generated wrapping interfaces have been built using the current Gtk+ for Windows All-In-One bundle available at:

[http://www.gtk.org/download/win32.php](http://www.gtk.org/download/win32.php)

This repository does not necessarily track Gtk+ for Win64 as the Gtk+ project still considers builds for this system "experimental."

Differences
-----------

The script for building wrappers has been modified to remove some hard-coded directory paths.  A command-line argument can now be used to provide a path to the base headers directory.

The CMake scripts have been fixed to allow Windows builds.  Some patches are present to fix reliance on UNIX-y utilities like sed.  Additional libraries have been added to the PlPlot build to account for the possible lack of pkgconfig executables on the path.  The PlPlot examples will not be built as the PlPlot dependencies on Windows without pkgconfig are a bit of a mess.

The largest change is the correction of a number of generated interfaces that are improperly declared by the wrapping script.  These compilation errors are not the fault of Gtk-Fortran's wrapper script but, rather, Gtk+ itself.  On Windows, a number of functions dealing with filenames are redefined via macros in the header files to have a *_utf8* suffix.  Most (probably not all) of these functions have been manually corrected in the wrapper interfaces.  The end-user should see no difference on his or her end.

Building
--------

To compile, you'll just need to run *cmake* in a empty directory and point it at this top-level directory.  You'll probably need an assortment of command-line options, specifically the paths to the includes and library files (*CMAKE_INCLUDE_PATH* AND *CMAKE_LIBRARY_PATH* respectively).  Use the "MinGW Makefiles" generator.

If you're using MinGW-W64, make sure to set "-m32" in CMAKE_C_FLAGS, CMAKE_Fortran_FLAGS, and CMAKE_LINKER_FLAGS.

After running cmake, *make* and *make install* should work just fine.

These modifications have only been tested with MinGW working from the Windows command shell.  They should work with MSYS as well, though.
