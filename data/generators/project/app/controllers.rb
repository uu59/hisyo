Hisyo::Application.controllers do
  get "/hi/:name" do
    "Hi, #{params[:name] || "Joe"}!"
  end
end
