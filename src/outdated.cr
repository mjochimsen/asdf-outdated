require "./asdf"
require "./version"

module Outdated
  VERSION = "0.1.0"

  # Get a list of outdated `asdf` plugins and the possible new versions.
  def self.run(plugins : Array(String))
    plugins.each do |plugin|
      ASDF.list_installed(plugin).each do |installed|
        upgrade = upgrade?(plugin, installed)
        puts "#{plugin} #{installed} (#{upgrade})" unless upgrade.nil?
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
