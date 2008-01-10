module Nanoc
  class LayoutProcessor < Plugin

    def initialize(page, site, other_assigns={})
      @page          = page
      @pages         = site.pages.map { |p| p.to_proxy }
      @config        = site.config
      @site          = site
      @other_assigns = other_assigns
    end

    def run(layout)
      error 'LayoutProcessor#run must be overridden'
    end

    # Extensions

    class << self
      attr_accessor :_extensions
    end

    def self.extensions(*extensions)
      self._extensions = [] unless instance_variable_defined?(:@_extensions)
      extensions.empty? ? self._extensions || [] : self._extensions = (self._extensions || []) + extensions
    end

    def self.extension(extension=nil)
      self._extensions = [] unless instance_variable_defined?(:@_extensions)
      extension.nil? ? self.extensions.first : self.extensions(extension)
    end

  end
end
