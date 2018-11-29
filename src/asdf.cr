# The `Outdated::ASDF` module wraps interactions with the `asdf`
# versioning utility.
module Outdated::ASDF
  extend self

  # Return a list of the `adsf` plugins installed on the system.
  def plugins : Array(String)
    `asdf plugin-list`.split
  end

  # Return a list of all the versions supported by a given `asdf`
  # *plugin*.
  def list_all(plugin : String) : Array(Version)
    `asdf list-all #{plugin}`.split
      .compact_map() { |version| Version.parse?(version) }
  end

  # Return a list of all the installed versions for a given `asdf`
  # *plugin*.
  def list_installed(plugin : String) : Array(Version)
    `asdf list #{plugin}`.split
      .compact_map { |version| Version.parse?(version) }
  end
end
