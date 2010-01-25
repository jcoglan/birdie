require 'sinatra'
require 'yaml'
require 'forwardable'

%w[book page image].each do |klass|
  require File.dirname(__FILE__) + '/birdie/' + klass
end

module Birdie
  class Application < Sinatra::Base
    
    PUBLIC_DIR   = File.join(APP_DIR, 'public')
    VIEW_DIR     = File.join(APP_DIR, 'views')
    CONTENT_FILE = File.join(APP_DIR, 'content.yml')
    
    set :static, true
    set :public, PUBLIC_DIR
    set :views,  VIEW_DIR
    
    get('/') { erb :index }
    ['', '/'].each { |trailer| get("/books#{trailer}") { redirect '/' } }
    
    get Book::ROUTE do
      @book = books.find { |b| b.slug == params[:slug] }
      @page = @book.page_at(1)
      erb :page
    end
    
    get Page::ROUTE do
      @book = books.find { |b| b.slug == params[:slug] }
      @page = @book.page_at(params[:id].to_i)
      erb :page
    end
    
    helpers do
      attr_reader :book, :page
      
      extend Forwardable
      def_delegator :book, :pages
      def_delegator :page, :images
      
      def content
        @content ||= YAML.load(File.read(CONTENT_FILE))
      end
      
      def books
        @books ||= content['books'].map(&Book.method(:new))
      end
      
      def link_to(object, link_text = nil)
        class_name = [@book, @page].include?(object) ? 'current' : ''
        "<a href=\"#{ object.path }\" class=\"#{ class_name }\">#{ link_text || object.title }</a>"
      end
      
      def image_tag(image)
        "<img src=\"#{ image.path }\">"
      end
    end
    
  end
end

