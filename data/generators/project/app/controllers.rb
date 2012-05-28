MyApp.controllers do
  get "/" do
    # render "index.str" at app/views/index.str
    render :str, :index
  end

  get "/hi/:name" do
    # `hi` is helper at app/helpers.rb
    hi(params[:name] || "joe")
  end
end
