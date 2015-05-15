require 'yaml'
require 'pathname'

module YamlStore
  module_function

  @@store = {}

  def store
    @@store
  end

  def load(*files)
    files.each do |f|
      yaml = Pathname.new(f)

      unless yaml.exist?
        raise "File not found #{f}"
      end

      key = yaml.basename.to_s.gsub(yaml.extname, '')
      @@store[key.to_sym] = read_yaml(yaml)

      self.class.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{key}
          store[:#{key}]
        end
      RUBY
    end
  end

  def get(name, key = nil)
    values = @@store[name]

    return nil unless values
    return key ? values[key] : values
  end

  def read_yaml(file)
    yml = YAML.load_file(file)

    if defined?(Rails)
      yml = yml[Rails.evn] || yml[Rails.evn.to_sym]
    end

    yml
  end
end
