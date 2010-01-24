module Birdie
  class Page
    
    ROUTE = Book::ROUTE + '/:id'
    
    attr_reader :images, :position
    
    def initialize(book, config, position)
      @book     = book
      @config   = config
      @images   = @config['images'].map(&Image.method(:new))
      @position = position
    end
    
    def path
      @book.path + "/#{ @position }"
    end
    
    def next
      @book.page_at(@position + 1)
    end
    
    def previous
      @book.page_at(@position - 1)
    end
    
  end
end

