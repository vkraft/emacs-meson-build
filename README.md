# emacs-meson-build

A very simple GNU Emacs package for using [Meson](http://mesonbuild.com/) to
build a project.

This is alpha-quality software (at best). Beware of bugs and oddities.


## Usage

1. If necessary, run `meson ${builddir}` in a shell to configure Meson as usual.
2. Set `meson-build-build-directory-name` to the relative path to your chosen build
   directory. The path should be relative to the root of your project (i.e. the
   directory that has the `meson.build` file in it).
3. Run `M-x meson-build-start-build` to start a build. (The current buffer
   must be visiting a file that is below the Meson project's root.)
