require "./spec_helper"

alias ASDF = Outdated::ASDF

describe ASDF do
  it "gets a list of plugins" do
    unless HELPER.plugin.nil?
      ASDF.plugins.should_not be_empty
    else
      ASDF.plugins.should be_empty
    end
  end

  it "gets a list of versions for a plugin" do
    plugin = HELPER.plugin
    unless plugin.nil?
      unless HELPER.all_versions.empty?
        ASDF.list_all(plugin).should_not be_empty
      else
        ASDF.list_all(plugin).should be_empty
      end
    end
  end

  it "gets a list of installed versions for a plugin" do
    plugin = HELPER.plugin
    unless plugin.nil?
      unless HELPER.installed_versions.empty?
        ASDF.list_installed(plugin).should_not be_empty
      else
        ASDF.list_installed(plugin).should be_empty
      end
    end
  end
end

HELPER = ASDFHelper.new

class ASDFHelper
  getter plugin : String?
  getter all_versions
  getter installed_versions

  def initialize
    @plugin = `asdf plugin-list`.split.first?
    @all_versions = @plugin ? `asdf list-all #{@plugin}` : ""
    @installed_versions = @plugin ? `asdf list #{@plugin}` : ""
  end
end
