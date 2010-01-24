require 'sinatra'
require 'yaml'

module Birdie
  class Application < Sinatra::Base
    
    PUBLIC_DIR   = File.join(APP_DIR, 'public')
    VIEW_DIR     = File.join(APP_DIR, 'views')
    CONTENT_FILE = File.join(APP_DIR, 'content.yml')
    
    require File.dirname(__FILE__) + '/birdie/book'
    require File.dirname(__FILE__) + '/birdie/page'
    require File.dirname(__FILE__) + '/birdie/image'
    
    set :static, true
    set :public, PUBLIC_DIR
    set :views,  VIEW_DIR
    
    get('/') { erb :index }
    
    get Book::ROUTE do
      @book = books.find { |b| b.slug == params[:slug] }
      @page = @book.pages.first
      erb :page
    end
    
    helpers do
      attr_reader :book
      
      def content
        return @content if defined?(@content)
        @content = YAML.load(File.read(CONTENT_FILE))
        @content['books'].map!(&Book.method(:new))
        @content
      end
      
      def books
        content['books']
      end
      
      def pages
        @book.pages
      end
      
      def link_to(object)
        "<a href=\"#{ object.path }\">#{ object.title }</a>"
      end
      
      def image_tag(image)
        "<img src=\"#{ image.path }\">"
      end
    end
    
  end
end

