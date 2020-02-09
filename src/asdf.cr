# The `Outdated::ASDF` module wraps interactions with the `asdf`
# versioning utility.
module Outdated::ASDF
  extend self

  @@plugins : Array(String)? = nil

  @@all_versions = Hash(String, Array(Version)).new do |versions, plugin|
    unless versions.has_key?(plugin)
      versions[plugin] = `asdf list-all #{plugin}`.split
        .compact_map { |version| Version.parse?(version) }
        .sort
    end
    versions[plugin]
  end

  @@installed_versions = Hash(String, Array(Version)).new do |versions, plugin|
    unless versions.has_key?(plugin)
      versions[plugin] = `asdf list #{plugin}`.split
        .compact_map { |version| Version.parse?(version) }
        .sort
    end
    versions[plugin]
  end

  # Return a list of the `adsf` plugins installed on the system.
  def plugins : Array(String)
    @@plugins = `asdf plugin-list`.split if @@plugins.nil?
    @@plugins.not_nil!
  end

  # Return a list of all the versions supported by a given `asdf`
  # *plugin*.
  def list_all(plugin : String) : Array(Version)
    @@all_versions[plugin]
  end

  # Return a list of all the installed versions for a given `asdf`
  # *plugin*.
  def list_installed(plugin : String) : Array(Version)
    @@installed_versions[plugin]
  end
end
