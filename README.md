# asdf-outdated

Show a list of the [`adsf`](https://github.com/asdf-vm/asdf) installed
versions, with notations for those which are outdated.

## Installation

You'll need the `crystal` toolchain installed to build this tool. See the
[Crystal installation](https://crystal-lang.org/docs/installation/) docs
for help.

Once the toolchain is installed, run:

    crystal build src/outdated.cr

## Usage

To get a list of installed version, with notations for those which are
outdated, run:

    asdf-outdated [plugin]

If no plugin is specified, then all installed plugins are assumed.

## Contributing

1. Fork it (<https://github.com/mjochimsen/asdf-outdated/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Michael Jochimsen](https://github.com/mjochimsen) - creator and maintainer
