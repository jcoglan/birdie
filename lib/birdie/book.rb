module Birdie
  class Book
    
    ROUTE = '/books/:slug'
    
    def initialize(config)
      @config = config
    end
    
    def pages
      return @pages if defined?(@pages)
      @pages = []
      @config['pages'].each_with_index do |page, i|
        @pages << Page.new(self, page, i + 1)
      end
      @pages
    end
    
    def title
      @config['title']
    end
    
    def slug
      @slug ||= @config['slug'] || title.downcase.strip.gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '')
    end
    
    def directory
      @config['directory'] || '.'
    end
    
    def path
      "/books/#{ slug }"
    end
    
    def page_at(position)
      position -= 1
      position -= pages.size if position >= pages.size
      pages[position]
    end
    
  end
end

