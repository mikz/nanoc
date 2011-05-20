module Nanoc3

  # Provides a context in which compilation and routing rules can be executed.
  # It provides access to the item representation that is being compiled or
  # routed.
  #
  # The following variables will be available in this rules context:
  #
  # * `rep`     ({Nanoc3::ItemRep})         - The current item rep
  # * `item`    ({Nanoc3::Item})            - The current item
  # * `site`    ({Nanoc3::Site})            - The site
  # * `config`  ({Hash})                    - The site configuration
  # * `items`   ({Array}<{Nanoc3::Item}>)   - A list of all items
  # * `layouts` ({Array}<{Nanoc3::Layout}>) - A list of all layouts
  #
  # @api private
  class RuleContext < Context

    # @option params [Nanoc3::ItemRep] :rep The item representation that will
    #   be processed in this rule context
    #
    # @option params [Nanoc3::Compiler] :compiler The compiler that is being
    #   used to compile the site
    #
    # @raise [ArgumentError] if the `:rep` or the `:compiler` option is
    #   missing
    def initialize(params={})
      rep      = params[:rep]      or raise ArgumentError, "Required :rep option is missing"
      compiler = params[:compiler] or raise ArgumentError, "Required :compiler option is missing"

      super({
        :rep     => rep,
        :item    => rep.item,
        :site    => compiler.site,
        :config  => compiler.site.config,
        :items   => compiler.site.items,
        :layouts => compiler.site.layouts
      })
    end

    # Filters the current representation (calls {Nanoc3::ItemRep#filter} with
    # the given arguments on the rep).
    #
    # @see Nanoc3::ItemRep#filter
    #
    # @param [Symbol] filter_name The name of the filter to run the item
    #   representations' content through
    #
    # @param [Hash] filter_args The filter arguments that should be passed to
    #   the filter's #run method
    #
    # @return [void]
    def filter(filter_name, filter_args={})
      rep.filter(filter_name, filter_args)
    end

    # Layouts the current representation (calls {Nanoc3::ItemRep#layout} with
    # the given arguments on the rep).
    #
    # @see Nanoc3::ItemRep#layout
    #
    # @param [String] layout_identifier The identifier of the layout the item
    #   should be laid out with
    #
    # @return [void]
    def layout(layout_identifier)
      rep.layout(layout_identifier)
    end

    # Creates a snapshot of the current compiled item content. Calls
    # {Nanoc3::ItemRep#snapshot} with the given arguments on the rep.
    #
    # @see Nanoc3::ItemRep#snapshot
    #
    # @param [Symbol] snapshot_name The name of the snapshot to create
    #
    # @return [void]
    def snapshot(snapshot_name)
      rep.snapshot(snapshot_name)
    end

  end

end
