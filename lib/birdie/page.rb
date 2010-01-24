module Birdie
  class Page
    
    ROUTE = Book::ROUTE + '/:id'
    
    attr_reader :images
    
    def initialize(config)
      @config = config
      @images  = @config['images'].map(&Image.method(:new))
    end
    
  end
end

