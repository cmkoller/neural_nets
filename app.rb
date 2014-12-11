require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'

configure :development, :test do
  require 'pry'
end

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

get '/:id' do
  @id = params[:id]
  @net = Net.find(params[:id])
  erb :index
end

post '/:id' do
  @net = Net.find(params[:id])
  if params[:add]
    @net.create_node(params[:add].to_i)
  elsif params[:delete]
    @net.delete_node(params[:delete].to_i)
  elsif params[:feed_forward]
    input = []
    @net.loop_over_nodes(0) do |i|
      if params["input_#{i}"]
        input << 1
      else
        input << 0
      end
      @net.feed_forward(input)
    end

      # binding.pry
  end
  redirect "/#{params[:id]}"
end
