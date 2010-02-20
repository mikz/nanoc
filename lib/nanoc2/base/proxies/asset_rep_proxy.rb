module Nanoc2

  # Nanoc2::AssetRepProxy is a proxy object for an asset representation
  # (Nanoc2::AssetRep).
  class AssetRepProxy < Proxy

    # Requests the asset representation attribute with the given name. +key+
    # can be a string or a symbol, and it can contain a trailing question mark
    # (which will be stripped).
    def [](key)
      real_key = key.to_s.sub(/\?$/, '').to_sym

      if real_key == :name
        @obj.name
      elsif real_key == :path
        @obj.web_path
      elsif real_key == :asset
        @obj.asset.to_proxy
      else
        super(key)
      end
    end

  end

end