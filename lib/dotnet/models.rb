module DotNet

  # Provides model-oriented mixins.
  module ModelMixin
    
    # Gets the underlying binding context.
    #
    # @return [Binding] the binding context of the current instance.
    def get_binding
      binding
    end

  end

  # Provides an open model object for use in rendering scenarios.
  class Model < OpenStruct
    include DotNet::ModelMixin

    # Creates a new model object by converting a hash of values.
    #
    # @param hash [Hash] the model data to initialize with.
    def initialize(hash)
      super hash
      yield self if block_given?
    end

  end

end
