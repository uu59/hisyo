MyApp.namespace "/" do
  get do
    # render "index.str" at app/views/index.str
    render :str, :index
  end

  get "hi/:name" do
    # `hi` is helper at app/helpers.rb
    hi(params[:name] || "joe")
  end

  # /admin/*
  namespace "admin" do
    before { halt 403, "Secret zone" }
    get "/secret" do
      "foobar"
    end
  end
end
