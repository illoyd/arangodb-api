module ArangoDB
  class DocumentHandle
    attr_reader :collection, :key

    def initialize(collection, key = nil)
      if key.nil?
        @collection, @key = collection.split('/')
      else
        @collection, @key = collection, key
      end
      @key = Integer(@key)
    end

    def handle
      "#{ collection }/#{ key }"
    end

    def model_name
      collection.classify
    end

    def model_class
      model_name.constantize
    end

    alias :to_s :handle

    def inspect
      "#<ArangoDB::DocumentHandle #{ to_s }>"
    end

    def ==(other)
      self.collection == other&.collection && self.key == other&.key
    end

  end # DocumentHandle

end # ArangoDB