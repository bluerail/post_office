require 'json'

class ConfigFile
  USER_CONFIG_DIR = ENV.fetch('XDG_CONFIG_HOME', ENV['HOME'] + '/.config')
  SYSTEM_CONFIG_DIR = '/etc'
  CONFIG_DIRS = [USER_CONFIG_DIR, SYSTEM_CONFIG_DIR]
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def self.detect
    filename =
      CONFIG_DIRS.map { |dir| "#{dir}/post_office/config.json" }
                 .detect { |file| File.exist? file }
    new(filename)
  end

  def read
    return {} if @filename.nil?
    JSON.parse(File.read(@filename), symbolize_names: true)
  end
end
