require 'dotnet_solutions/version'
require 'json'
require 'pathname'

require_relative 'files'

module DotNetSolutions
  class Solution
    attr_accessor :files, :sln

    def initialize(solution_file = Files::DEFAULT_JSON, config_file = Files::DEFAULT_YAML)
      @files = {
        :sln => Pathname.new(solution_file),
        :cfg => Pathname.new(config_file)
      }
      @sln = load_or_create_solution @files
    end

    def load_or_create_solution(files)
      files[:sln].exist? ? Files.load_json(files[:sln]) : create_new(files[:sln])
    end

    def create_new(path)
      sln = {
        :solution_name => File.basename(Dir.pwd),
        :packages => [],
        :projects => []
      }

      sln_json = JSON.pretty_generate(sln)

      File.open(path, 'w'){|file| file.write(sln_json)}

      sln
    end

    def generate_vs_files
      #1. Find latest version of VS
      #2. Pass solution.json & latest version & generator.yml to generator (ERB)
      #3. For each project in solution.json, pass data & generator.yml to generator (ERB)
      #3a. Use defaults for missing elements
    end
  end
end
