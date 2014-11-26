require 'etc'

require_relative './models'
require_relative './files'

module DotNet
  
  # Provides file generation capabilities for solution metadata.
  class SolutionMetadata

    # Initializes a new instance.
    #
    # @param hash [Hash] a hash containing metadata values.
    # @param solution [Solution] the current solution.
    def initialize(hash, solution)
      @hash = hash
      @solution = solution
    end

    # Generates the AssemblyInfo file for a given project.
    #
    # @param project [Model] the model data for the current project.
    # @return [void]
    def generate_assembly_info(project)
      info = load_model(@hash, project).get_binding
      DotNet::Files.write_assembly_info project, info
    end

    private

    attr_accessor :hash, :solution

    def load_model(hash, project)
      DotNet::Model.new hash do |model|
        model.title ||= project.name
        model.product ||= model.title
        model.company ||= Etc.getlogin
        model.description ||= project.description || "#{project.name} #{project.type} for #{@solution.name}"
        model.id = project.id
        model.solution_version = @solution.version
        model.version = project.version || @solution.version
      end
    end
  end

end
