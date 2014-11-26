# .NET Solutions (for Ruby)

Used to generate and maintain metadata for .NET development. With a few simple files, you can eliminate the need to check in `*.sln`, `*.csproj`, `*.vbproj`, `*.fsproj`, `AssemblyInfo.*`, `packages.config`, and `.nuget/` ever again!

## Installation

Add this line to your application's Gemfile:

    gem 'dotnet_solutions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dotnet_solutions

## Usage
In your `VERSION`:
```
0.0.1
```

In your `Rakefile`:
```ruby
require 'dotnet/tasks'
require 'albacore'

desc 'Generate all solution files'
generate_dotnet :gen_sln do |sln|
  sln.path = './src/dotNet/solution.rb'
  sln.version = File.read('./VERSION')
end

desc 'Build all .NET source code'
msbuild :build_sln => :gen_sln do |sln|
  sln.solution = './src/dotNet/MySolution.sln'
end
```

In your `solution.rb`:
```ruby
DotNet::Solution.new do |sln|
  sln.name = 'MySolution'
  sln.set_metadata({ :product => 'MyInvention', :company => 'MyEmpire' })
  sln.add_project({ :name => 'MySolution.Core' })
end
```

In your `.gitignore`:
```
# Created by https://www.gitignore.io

### VisualStudio ###
... clipped for brevity ...

### dotnet_solutions ###
*.sln
*.csproj
*AssemblyInfo.cs
packages.config
.nuget/
```

Finally, at the command line:
```bash
$ rake build_sln
```

You just built `MySolution.Core.dll`, version `0.0.1`! Time to open `MySolution.sln` up in Visual Studio (or your favorite alternative) and get to work. Just don't forget to add your code via git before re-running your new rake tasks :grinning:

## Contributing

1. Fork it ( https://github.com/TheTribe/dotnet_solutions/fork )
2. Create issue to associate feature with ( https://github.com/TheTribe/dotnet_solutions/issues/new )
3. Clone your fork ( `git clone https://github.com/[your_user_name]/dotnet_solutions.git -b next` )
4. Create your feature branch ( `git checkout -b feature/issue-number` )
5. Commit your changes ( `git commit -am 'Add some feature'` )
6. Push to the branch ( `git push origin feature/issue-number` )
7. Create a new Pull Request to `TheTribe`:`next` branch, or to the correct milestone branch if applicable