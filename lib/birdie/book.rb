module Birdie
  class Book
    
    ROUTE = '/books/:slug'
    
    attr_reader :pages
    
    def initialize(config)
      @config = config
      @pages = []
      @config['pages'].each_with_index do |page, i|
        @pages << Page.new(self, page, i + 1)
      end
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

