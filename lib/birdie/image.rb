module Birdie
  class Image
    
    TYPES = %w[.jpg .png] + ['']
    
    attr_reader :path
    
    def initialize(path)
      @path = TYPES.map { |t| "/images/#{path}#{t}" }.find do |path|
        File.file?(File.join(Application::PUBLIC_DIR, path))
      end
    end
    
  end
end

