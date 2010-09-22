module Birdie
  class Page
    
    ROUTE = Book::ROUTE + '/:id'
    
    attr_reader :position
    
    def initialize(book, config, position)
      @book     = book
      @config   = config
      @position = position
    end
    
    def images
      @images ||= [*@config['images']].map { |img| Image.new(File.join(@book.directory, img)) }
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

