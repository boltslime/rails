# frozen_string_literal: true

module ActiveRecord
  class FixtureSet
    class ModelMetadata # :nodoc:
      def initialize(model_class, table_name)
        @model_class = model_class
        @table_name  = table_name
      end

      def primary_key_name
        @primary_key_name ||= @model_class && @model_class.primary_key
      end

      def primary_key_type
        @primary_key_type ||= @model_class && @model_class.type_for_attribute(@model_class.primary_key).type
      end

      def has_primary_key_column?
        @has_primary_key_column ||= primary_key_name &&
          @model_class.columns.any? { |col| col.name == primary_key_name }
      end

      def timestamp_column_names
        @timestamp_column_names ||=
          %w(created_at created_on updated_at updated_on) & column_names
      end

      def inheritance_column_name
        @inheritance_column_name ||= @model_class && @model_class.inheritance_column
      end

      private

        def column_names
          @column_names ||= @model_class.connection.columns(@table_name).collect(&:name)
        end
    end
  end
end
