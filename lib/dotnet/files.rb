require 'fileutils'
require 'pathname'

require_relative './constants'
require_relative './templates/loader'

module DotNet

  class Files

    # Writes the solution file to its destination.
    #
    # @param solution [Object] the solution to render.
    # @return [void]
    def self.write_solution_file(solution)
      content = render solution_template, solution.get_binding
      path = Pathname.new(solution.directory).join("#{solution.name}.sln").realdirpath
      generate path, content
    end

    # Writes the project file to its destination.
    #
    # @param project [Object] the project to render.
    # @return [void]
    def self.write_project_file(project)
      content = render project_template(project.language), project.get_binding
      path = Pathname.new(project.directory)
        .join("#{project.name}.#{project_file_extension(project.language)}")
        .realdirpath
      generate path, content
    end

    # Write the AssemblyInfo file to a project-specific destination.
    #
    # @param project [Object] the project to use during rendering.
    # @param context [Binding] the binding context for the assembly info.
    # @return [void]
    def self.write_assembly_info(project, context)
      path = Pathname.new(project.directory).join(PROJECT_METADATA_FOLDER)
      FileUtils.mkdir_p path.to_s
      content = render assembly_info_template(project.language), context
      file_path = path.join(assembly_info_file(project.language)).realdirpath
      generate file_path, content
    end

    private

    PROJECT_METADATA_FOLDER = 'Properties'
    PROJECT_METADATA_FILE = 'AssemblyInfo'

    def self.source_file_extension(language)
      case language
      when DotNet::Languages::CSHARP
        'cs'
      when DotNet::Languages::FSHARP
        'fs'
      when DotNet::Languages::VB
        'vb'
      else
        raise "The language #{language} is not supported."
      end
    end

    def self.render(template, context)
      DotNet::Templates::Loader.render_template template, context
    end

    def self.generate(path, content)
      File.open(path, 'w') { |file| file.write content }
      puts "GENERATED #{path}"
    end

    def self.assembly_info_file(language)
      "#{PROJECT_METADATA_FILE}.#{source_file_extension(language)}"
    end

    def self.assembly_info_template(language)
      "#{assembly_info_file(language)}.erb"
    end

    def self.project_file_extension(language)
      "#{source_file_extension(language)}proj"
    end

    def self.project_template(language)
      "#{project_file_extension(language)}.erb"
    end

    def self.solution_template
      'sln.erb'
    end

  end

end
