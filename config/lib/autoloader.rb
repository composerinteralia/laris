module Laris
  ROOT = File.join(File.dirname(__FILE__), "..", "..")
  AUTOLOAD_PATHS = [
    "app/models",
    "app/models/lib",
    "app/controllers",
    "app/controllers/lib",
    "config/lib",
  ]
end

class Object
  def self.const_missing(const)
    auto_load(const)
    Kernel.const_get(const)
  end

  private
  def auto_load(const)
    Laris::AUTOLOAD_PATHS.each do |folder|
      file = File.join(Laris::ROOT, folder, const.to_s.underscore)
      return if try_auto_load(file)
    end
  end

  def try_auto_load(file)
    require_relative(file)
    return true
  rescue LoadError
    false
  end
end

class Module
  def const_missing(const)
    Object.const_missing(const)
  end
end
