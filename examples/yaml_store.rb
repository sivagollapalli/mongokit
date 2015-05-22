
file = Dir['/Users/jirenpatel/work/cricket_editor/config/*.yml']
YamlStore.load *file
puts YamlStore.get(:services, 'default')

puts YamlStore.services

YamlStore.get(:aws, :api_key)
