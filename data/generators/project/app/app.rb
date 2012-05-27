# Feel free to rename from "MyApp" to anything
# if so, remember changing config.ru
class MyApp < Hisyo::Application
  get "/" do
    hello("MyApp")
  end
end
