=begin
Setup Sprockets and define `get /assets/*` route by default.
You can visit /assets/foo for get compiled asset

See also: https://github.com/sstephenson/sprockets
=end

MyApp.class_eval do
  set :sprockets, Sprockets::Environment.new(root)
  set :assets_prefix, '/assets'
  set :assets_digest, true

  configure do
    sprockets.append_path File.join(root, 'app', 'assets', 'stylesheets')
    sprockets.append_path File.join(root, 'app', 'assets', 'javascripts')

    #sample config for compression
    #sprockets.js_compressor = Uglifier.new
    #sprockets.css_compressor = YUI::CssCompressor.new
  end

  helpers do
    def javascript_path(path)
      path << ".js" if File.extname(path).empty?
      asset_path(path)
    end

    def stylesheet_path(path)
      path << ".css" if File.extname(path).empty?
      asset_path(path)
    end

    def asset_path(path)
      return path if path.match %r!^(?:https?:)//!

      asset = settings.sprockets.find_asset(path)
      raise "asset not found for '#{path}'" unless asset
      basename = settings.assets_digest ? asset.digest_path : asset.logical_path
      File.join(settings.assets_prefix, basename)
    end
  end

  get "#{settings.assets_prefix}/*" do
    path = params[:splat].last.sub(%r!^/!, "")
    if digest = path[/-[0-9a-f]+\./]
      path.sub!(digest, ".")
      expires 8640000, :public
    end
    asset = settings.sprockets.index.find_asset path
    halt 404, "asset not found '#{path}'" unless asset
    content_type mime_type(path).nil? ? "text/plain" : File.extname(path)
    asset.to_s
  end
end
