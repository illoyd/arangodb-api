module ArangoDB
  ##
  # HTTP REST client for the ArangoDB API.
  class Resource < SimpleDelegator

    def initialize(client, *paths)
      super(client)
      @path = paths.compact.join('/')
    end

    alias :client :__getobj__

    def resource(*paths)
      __getobj__.resource(@path, *paths)
    end

    Faraday::Connection::METHODS.each do |method|
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{method}(*args, &block)
          __getobj__.#{method}(@path, *args, &block)
        end
      RUBY
    end

  end # Resource
end # ArangoDB
