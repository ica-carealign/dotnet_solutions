require 'ember'

module DotNet

  module Templates

    # Provides ERB template loading / rendering.
    class Loader

      # Renders the named template with the given evaluation context.
      #
      # @param name [String] the name of the template to render.
      # @param context [Binding] the evaluation context to render with.
      # @return [String] the result of the ERB evaluation.
      def self.render_template(name, context)
        template = Ember::Template.load_file(File.join(File.dirname(__FILE__), name), {})
        template.render context
      end

    end

  end

end
