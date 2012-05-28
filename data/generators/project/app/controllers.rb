Hisyo::Application.controllers do
  get "/hi/:name" do
    # `hi` is helper at app/helpers.rb
    hi(params[:name] || "joe")
  end
end
