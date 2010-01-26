require 'sinatra'
require 'yaml'
require 'forwardable'

%w[book page image].each do |klass|
  require File.dirname(__FILE__) + '/birdie/' + klass
end

module Birdie
  class Application < Sinatra::Base
    
    PUBLIC_DIR    = File.join(APP_DIR, 'public')
    VIEW_DIR      = File.join(APP_DIR, 'views')
    CONTENT_FILE  = File.join(APP_DIR, 'content.yml')
    FEED_FILE     = File.join(APP_DIR, 'feed.yml')
    
    FEED_ROUTE    = '/feed.xml'
    FEED_TEMPLATE = File.join(File.dirname(__FILE__), 'feed.erb')
    
    set :static, true
    set :public, PUBLIC_DIR
    set :views,  VIEW_DIR
    
    get('/') { erb :index }
    ['', '/'].each { |trailer| get("/books#{trailer}") { redirect '/' } }
    
    get Book::ROUTE do
      # TODO handle missing book
      @book = books.find { |b| b.slug == params[:slug] }
      @page = @book.page_at(1)
      erb :page
    end
    
    get Page::ROUTE do
      # TODO handle missing book/page
      @book = books.find { |b| b.slug == params[:slug] }
      @page = @book.page_at(params[:id].to_i)
      erb :page
    end
    
    get FEED_ROUTE do
      # TODO handle missing feed
      extend(RssHelper)
      feed = YAML.load(File.read(FEED_FILE))
      template = ERB.new(File.read(FEED_TEMPLATE), nil, '-')
      template.result(binding)
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
      
      def rss_feed_link(url = FEED_ROUTE)
        return "" unless File.file?(FEED_FILE)
        "<link rel=\"alternate\" title=\"RSS\" type=\"application/rss+xml\" href=\"#{ url }\">"
      end
    end
    
    module RssHelper
      def domain
        "#{ request.scheme }://#{ request.host }"
      end
      
      def rss_object_for(item)
        return books.find { |b| b.slug == item['book'] } if item['book']
        nil
      end
      
      def rss_title_for(item)
        item['title'] || rss_object_for(item).title
      end
      
      def rss_link_for(item)
        domain + ( item['link'] || rss_object_for(item).path )
      end
      
      def rss_description_for(item)
        item['description'] || rss_object_for(item).title
      end
      
      def rss_date_for(item)
        item['date'].strftime('%a, %d %b %Y 00:00:00 GMT')
      end
    end
    
  end
end

