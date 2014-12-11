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

get '/' do
  erb :index
end

get '/new-net' do
  net = Net.create
  redirect :"/net/#{net.id}"
end

get '/net/:id' do
  @id = params[:id]
  @net = Net.find(params[:id])
  erb :net
end

post '/net/:id' do
  @net = Net.find(params[:id])
  if params[:add]
    @net.create_node(params[:add].to_i)
  elsif params[:delete]
    @net.delete_node(params[:delete].to_i)
  end
  redirect "/net/#{params[:id]}"
end

get '/net/:id/inputs' do
  @net = Net.find(params[:id])
  @first_layer_size = @net.first_layer_nodes.length
  @last_layer_size = @net.last_layer_nodes.length
  erb :in_outs
end

post '/net/:id/inputs' do
  @net = Net.find(params[:id])
  @first_layer_size = @net.first_layer_nodes.length
  @last_layer_size = @net.last_layer_nodes.length

  input_vals = []
  @first_layer_size.times do |i|
    if params["input_#{i}"]
      input_vals << 1
    else
      input_vals << 0
    end
  end

  output_vals = []
  @last_layer_size.times do |i|
    if params["output_#{i}"]
      output_vals << 1
    else
      output_vals << 0
    end
  end

  input = PresetInput.create(values: input_vals.join(""), net_id: @net.id,
    name: params[:input_name])
  output = DesiredOutput.create(values: output_vals.join(""), net_id: @net.id,
    name: params[:output_name], preset_input_id: input.id)
  # @net.feed_forward(input)
  redirect "/net/#{params[:id]}/inputs"
end

get '/net/:id/run' do
  @id = params[:id]
  @net = Net.find(params[:id])
  if params[:feed_forward]
    @input = PresetInput.find(params[:selected_input])
    @output = DesiredOutput.find_by(preset_input_id: @input.id)
    @net.feed_forward(@input.values.split(""))
  end

  erb :run
end
