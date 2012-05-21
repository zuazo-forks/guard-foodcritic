# Guard::Foodcritic

[![Build History][2]][1] [![Dependency Status][4]][3]

Guard::Foodcritic automatically runs foodcritic.

[1]: http://travis-ci.org/cgriego/guard-foodcritic
[2]: https://secure.travis-ci.org/cgriego/guard-foodcritic.png?branch=master
[3]: https://gemnasium.com/cgriego/guard-foodcritic
[4]: https://gemnasium.com/cgriego/guard-foodcritic.png

## Installation

Please be sure to have [Guard](https://github.com/guard/guard) installed before continuing.

Install the gem:

    $ gem install guard-foodcritic

Add the guard-foodcritic definition to your Guardfile by running this command:

    $ guard init foodcritic

## Options

```ruby
:all_on_start => false    # Whether to run Foodcritic on all cookbooks at startup
                          # default: true

:cli => "--epic-fail any" # Command line arguments passed to foodcritic
                          # default: "--epic-fail any"

:cookbook_paths => "."    # The path(s) to your cookbooks
                          # default: ["cookbooks"]
```
