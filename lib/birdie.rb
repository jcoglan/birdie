require 'sinatra'
require 'yaml'

module Birdie
  class Application < Sinatra::Base
    
    PUBLIC_DIR   = File.join(APP_DIR, 'public')
    VIEW_DIR     = File.join(APP_DIR, 'views')
    CONTENT_FILE = File.join(APP_DIR, 'content.yml')
    
    autoload :Book, File.dirname(__FILE__) + '/birdie/book'
    
    set :static, true
    set :public, PUBLIC_DIR
    set :views,  VIEW_DIR
    
    get('/') { erb :index }
    
    helpers do
      def content
        return @content if defined?(@content)
        @content = YAML.load(File.read(CONTENT_FILE))
        @content['books'].map!(&Book.method(:new))
        @content
      end
      
      def books
        content['books']
      end
      
      def link_to(object)
        "<a href=\"#{ object.path }\">#{ object.title }</a>"
      end
    end
    
  end
end

