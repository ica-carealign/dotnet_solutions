require_relative './options'
require_relative './solutions'

# Generates a complete .NET solution to accompany your source.
#
# @param args [Array] the task arguments.
# @param block [Block] the options assignments to use.
# @return [void]
def generate_dotnet(*args, &block)
  options = DotNet::GeneratorOptions.new
  block.call options

  body = proc {
    sln = DotNet::Solution.load options.path
    sln.version = options.version if options.version
    sln.generate_files
  }

  Rake::Task.define_task(*args, &body)
end
