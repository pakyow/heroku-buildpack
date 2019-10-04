# This function will install a version of Ruby onto the
# system for the buidlpack to use. It coordinates download
# and setting appropriate env vars for execution
#
# Example:
#
#   install_ruby "$BIN_DIR" "$BUILDPACK_DIR"
#
# Takes two arguments, the first is the location of the buildpack's
# `bin` directory. This is where the `download_ruby` script can be
# found. The second argument is the root directory where Ruby
# can be installed.
#
# This function relies on the env var `$STACK` being set. This
# is set in codon outside of the buildpack. An example of a stack
# would be "cedar-14".
#
# Relies on global scope to set the variable `$ruby_dir`
# that can be used by other scripts
install_ruby()
{
  local bin_dir=$1
  local buildpack_dir=$2
  ruby_dir="$buildpack_dir/vendor/ruby/$STACK"

  # The -d flag checks to see if a file exists and is a directory.
  # This directory may be non-empty if a previous compile has
  # already placed a Ruby executable here. Also
  # when the buildpack is deployed we vendor a ruby executable
  # at this location so it doesn't have to be downloaded for
  # every app compile
  if [ ! -d "$ruby_dir" ]; then
    ruby_dir=$(mktemp -d)
    # bootstrap ruby
    $bin_dir/support/download_ruby "$BIN_DIR" "$ruby_dir"
    function atexit {
      rm -rf $ruby_dir
    }
    trap atexit EXIT
  fi

  # Even if a Ruby is already downloaded for use by the
  # buildpack we still have to set up it's PATH and GEM_PATH
  export PATH=$ruby_dir/bin/:$PATH
  unset GEM_PATH
}
