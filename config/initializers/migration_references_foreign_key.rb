require 'active_record/connection_adapters/abstract/schema_definitions'

module ActiveRecord::ConnectionAdapters
  module ReferenceDefinitionWithForeignKey
    def initialize(name, **options)
      options[:foreign_key] = true unless options.include?(:foreign_key)
      super
    end
  end

  ReferenceDefinition.send(:prepend, ReferenceDefinitionWithForeignKey)
end