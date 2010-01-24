module Birdie
  class Book
    
    ROUTE = '/book/:slug'
    
    def initialize(config)
      @config = config
      p config
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

