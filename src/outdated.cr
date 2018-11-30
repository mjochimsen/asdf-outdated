require "./asdf"
require "./version"

module Outdated
  VERSION = "0.1.0"

  # Get a list of outdated `asdf` plugins and the possible new versions.
  def self.run(plugins : Array(String))
  end
end

# Never run if we're under test.
unless nil.responds_to?(:should)
  args = ARGV.empty? ? Outdated::ASDF.plugins : ARGV
  Outdated.run(args)
end
