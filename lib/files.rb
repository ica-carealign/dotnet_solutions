require 'ember'
require 'json'

require_relative 'symbolizer'

module DotNetSolutions
  class Files
    DEFAULT_JSON = 'solution.json'
    DEFAULT_YAML = 'generator.yml'

    def self.templates
      File.join(File.dirname(File.expand_path(__FILE__)), 'templates')
    end

    def self.load_ember(file, model)
      erb = Ember::Template.load_file(file, {})
      erb.render(model)
    end

    def self.load_json(file)
      hash = JSON.parse(File.read file)
      Symbolizer.convert hash
    end

    def self.save_json(path, data)
      json = JSON.pretty_generate(data)
      save path, json
    end

    def self.save(path, text)
      File.open(path, 'w'){|file| file.write(text)}
    end
  end
end
