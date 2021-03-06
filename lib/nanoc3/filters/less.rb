# encoding: utf-8

require 'less'

module Nanoc3::Filters
  class Less < Nanoc3::Filter

    # Runs the content through [LESS](http://lesscss.org/).
    # This method takes no options.
    #
    # @param [String] content The content to filter
    #
    # @return [String] The filtered content
    def run(content, params={})
      # FIXME way too much code duplication between this and the Sass filter

      # Find imports (hacky)
      imports = []
      imports.concat(content.scan(/^@import\s+(["'])([^\1]+)\1;/))
      imports.concat(content.scan(/^@import\s+url\((["']?)([^)]+)\1\);/))
      imported_filenames = imports.map { |i| i[1] }

      # Convert to items
      imported_items = imported_filenames.map do |filename|
        # Find directory for this item
        current_dir_pathname = Pathname.new(@item[:content_filename]).dirname.realpath

        # Find absolute pathname for imported item
        imported_pathname    = Pathname.new(filename)
        if imported_pathname.relative?
          imported_pathname = current_dir_pathname + imported_pathname
        end
        next if !imported_pathname.exist?
        imported_filename = imported_pathname.realpath

        # Find matching item
        @items.find do |i|
          next if i[:content_filename].nil?
          Pathname.new(i[:content_filename]).realpath == imported_filename
        end
      end.compact

      # Create dependencies
      imported_items.each do |i|
        Nanoc3::NotificationCenter.post(:visit_started, i)
        Nanoc3::NotificationCenter.post(:visit_ended,   i)
        any_uncompiled_rep = i.reps.find { |r| !r.compiled? }
        raise Nanoc3::Errors::UnmetDependency.new(any_uncompiled_rep) if any_uncompiled_rep
      end

      # Add filename to load path
      paths = [ File.dirname(@item[:content_filename]) ]
      parser = ::Less::Parser.new(:paths => paths)
      parser.parse(content).to_css
    end

  end
end
