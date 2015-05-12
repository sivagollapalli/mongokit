require 'yaml'

module YamlStore
  module_function

  @@store = {}

  def store
    @@store
  end

  def load(*files)
    files.each do |f|
      key = f.split('/').last.split('.').first
      @@store[key.to_sym] = read_yaml(f)
      _define_accessor_(key)
    end
  end

  def get(name, key = nil)
    values = @@store[name]

    if values
      return key ? values[key] : values
    else
      nil
    end
  end

  def _define_accessor_(name)
    self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
      def #{name}
        store[:#{name}]
      end
    RUBY
  end

  def read_yaml(file)
    yml = YAML.load_file(file)

    env_present = [:development, :production, :test].any? do |e|
      yml[e.to_sym] || yml[e.to_s]
    end

    if defined?(Rails) && env_present
      yml = yml[Rails.evn] || yml[Rails.evn.to_sym]
    end

    yml
  end
end
