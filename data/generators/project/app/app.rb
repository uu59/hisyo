class MyApp < Hisyo::Application
  get "/" do
    hello("MyApp")
  end
end
