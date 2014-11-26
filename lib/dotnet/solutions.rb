require_relative './files'
require_relative './metadata'
require_relative './models'
require_relative './projects'

module DotNet
  
  # Provides an entry point for solution generation scenarios.
  class Solution
    include DotNet::ModelMixin

    attr_accessor :name, :version
    attr_reader :packages, :projects, :metadata, :directory

    # Initializes a new instance.
    def initialize
      @packages = []
      @projects = []
      yield self if block_given?
    end

    # Sets the root directory of the solution.
    #
    # @param dir [String] the path to the solution directory.
    # @return [void]
    def set_directory(dir)
      @directory = dir
      @projects.each { |project| project.set_relative_directory(@directory) }
    end

    # Adds a new package reference.
    #
    # @param package [Hash] the hash of package ref information to use.
    # @return [void]
    def add_package_ref(package)
      @packages << package
    end

    # Adds a new project to the collection.
    #
    # @param project_data [Hash] the hash of project values to initialize a new project with.
    # @return [Project] the new project.
    def add_project(project_data)
      project = DotNet::Project.new(project_data)
      @projects << project
      project
    end

    # Sets the metadata to use for the current solution.
    #
    # @param metadata [Hash] the hash of metadata to use.
    # @return [SolutionMetadata] the new metadata.
    def set_metadata(metadata)
      @metadata = DotNet::SolutionMetadata.new(metadata, self)
    end

    # Generates files for the current solution.
    # @return [void]
    def generate_files
      @metadata ||= DotNet::SolutionMetadata.new({}, self)

      DotNet::Files.write_solution_file self

      @projects.each do |project|
        project.generate_project_file
        @metadata.generate_assembly_info project.model
      end
    end

    # Loads the solution from an external file. The file is run in
    # "safe-mode"; that is, operations that require elevated permissions
    # will fail.
    #
    # @param file [String] the path to the solution file.
    # @return [Solution] the loaded solution.
    def self.load(file)
      sandbox = Fiber.new {$SAFE = 4; Fiber.yield binding}.resume
      sln = eval File.read(file), sandbox
      sln.set_directory File.dirname(file)
      sln
    end
  end
end
