module Birdie
  class Book
    
    ROUTE = '/books/:slug'
    
    attr_reader :pages
    
    def initialize(config)
      @config = config
      @pages  = @config['pages'].map(&Page.method(:new))
    end
    
    def title
      @config['title']
    end
    
    def slug
      @slug ||= title.downcase.strip.gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '')
    end
    
    def path
      "/books/#{ slug }"
    end
    
  end
end

