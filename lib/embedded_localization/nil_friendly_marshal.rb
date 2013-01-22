module EmbeddedLocalization
  class NilFriendlyMarshal
    def initialize(opts = nil)
      @opts = opts
      @opts ||= { :default => Hash.new() }
    end

    def load(str)
      if str.nil?
        return default_value
      else
        Marshal.load(str) || default_value
      end
    end

    def dump(str)
      Marshal.dump(str)
    end

    def self.load(str)
      EmbeddedLocalization::NilFriendlyMarshal::DEFAULT.load(str)
    end

    def self.dump(str)
      EmbeddedLocalization::NilFriendlyMarshal::DEFAULT.dump(str)
    end

    private
    def default_value
      @opts[:default].duplicable? ? @opts[:default].dup : @opts[:default]
    end
  end

  extend ActiveSupport::Concern

  module ClassMethods
    def marshal_store(store_attribute, options={})
      serialize(store_attribute, NilFriendlyMarshal)
      store_accessor(store_attribute, options[:accessors]) if options.has_key? :accessors
    end
  end
end

EmbeddedLocalization::NilFriendlyMarshal::DEFAULT = EmbeddedLocalization::NilFriendlyMarshal.new
