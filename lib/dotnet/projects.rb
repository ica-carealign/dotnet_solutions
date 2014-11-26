require 'fileutils'
require 'pathname'
require 'securerandom'

require_relative './constants'
require_relative './files'
require_relative './models'

module DotNet
  
  # Provides file generation capabilities for projects.
  class Project
    attr_reader :model

    # Creates a new instance.
    #
    # @param hash [Hash] a hash containing project values.
    def initialize(hash)
      @model = load_model hash
      @model.id = SecureRandom.uuid.upcase
    end

    # Sets the directory relative to a given root.
    #
    # @param root [String] the path to the solution root.
    # @return [void]
    def set_relative_directory(root)
      @model.directory = Pathname.new(root).join(@model.name).to_s
    end

    # Generates the project file.
    # @return [void]
    def generate_project_file
      FileUtils.mkdir_p @model.directory if !File.directory? @model.directory
      load_project_files
      DotNet::Files.write_project_file @model
    end

    private

    def load_model(hash)
      DotNet::Model.new hash do |model|
        model.assembly_name ||= model.name
        model.root_namespace ||= model.assembly_name
        model.type ||= DotNet::ProjectTypes::LIBRARY
        model.language ||= DotNet::Languages::CSHARP
        model.package_refs ||= []
        model.file_name = "#{model.name}.#{DotNet::Files.project_file_extension(model.language)}"
      end
    end

    def load_project_files
      FileUtils.cd @model.directory do
        puts "Adding git-indexed files from #{@model.directory}"
        @model.files = `git ls-files`.split(/$/m).map { |file| file.strip }.select { |file| !file.to_s.empty? }
      end
    end
  end

end
