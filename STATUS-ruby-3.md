Maint won't work with Ruby 3.0 as things stand.

Rails vs Ruby compatibility
---------------------------
According to the [compatibility matrix](https://www.fastruby.io/blog/ruby/rails/versions/compatibility-table.html), 
the lowest version of Rails compatible with Ruby 3.x is Rails 6.1.  At the time of writing, Maint only supports Rails 5.x.


libv8 requires Python 2
-----------------------
macOS Monterey doesn't include Python 2 anymore.  Python 2 is required by libv8 (at least it is if bundler needs to build
it from source).  To install Python 2.7.18 (from https://www.alfredapp.com/help/kb/python-2-monterey/),
execute the following (preferably in a new shell because it changes $PATH):
```
export PATH="/opt/homebrew/bin:/usr/local/bin:${PATH}"
eval "$(brew shellenv)"
brew install pyenv
pyenv install 2.7.18
ln -s "${HOME}/.pyenv/versions/2.7.18/bin/python2.7" "${HOMEBREW_PREFIX}/bin/python"
```

Ruby 3.0.4
----------
To install `therubyracer` gem, you have to use [workarounds](https://gist.github.com/fernandoaleman/868b64cd60ab2d51ab24e7bf384da1ca):
```
brew install v8@3.15
bundle config build.libv8 --with-system-v8
bundle config build.therubyracer --with-v8-dir=$(brew --prefix v8@3.15)
bundle install
```
Debugging Ruby 3.0 in RubyMine 2022.1 seems to be impossible at present (???).  The debugging gems `debase` and 
`ruby-debug-ide` are not usable.  `debase-0.25.beta2` can be built:
```
gem 'debase', :git => 'https://github.com/ruby-debug/debase.git', :tag => 'v0.2.5.beta2'
```

It's not really clear whether `ruby-debug-ide` builds properly with Ruby 3.0.4 on Monterey.  It seemed to fail, but
subsequently Bundler said the bundle was complete.

Ruby 3.1
--------
Unfortunately, it's not so easy in Ruby. 3.1.  That includes psych-4 as a "default" (hard-coded in) gem which can't be
removed, and [psych-4 is incompatible with libv8](https://github.com/rubyjs/mini_racer/issues/208)  (for now at least).
I have not found a solution to this, aside from reverting to ruby 3.0.4.
