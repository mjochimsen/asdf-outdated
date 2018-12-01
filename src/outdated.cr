require "./asdf"
require "./version"

module Outdated
  VERSION = "0.1.0"

  # Show a list of the installed versions, with notations for those which
  # are outdated.
  def self.run(plugins : Array(String))
    plugins.each do |plugin|
      ASDF.list_installed(plugin).each do |installed|
        STDOUT << plugin << " " << installed
        upgrade = upgrade?(plugin, installed)
        STDOUT << " < " << upgrade unless upgrade.nil?
        STDOUT << "\n"
      end
    end
  end

  private def self.upgrade?(plugin, installed)
    ASDF.list_all(plugin)
      .select { |version| version > installed }
      .min?
  end
end

# Never run if we're under test.
unless nil.responds_to?(:should)
  args = ARGV.empty? ? Outdated::ASDF.plugins : ARGV
  Outdated.run(args)
end
