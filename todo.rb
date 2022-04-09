require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  session[:lists] ||= []
end

get "/" do
  redirect "/lists"
end

# View list of lists
get "/lists" do
  @lists = session[:lists]

  erb :lists, layout: :layout
end

# Render the new list form
get "/lists/new" do
  erb :new_list, layout: :layout
end

# create a new list
post "/lists" do
  list_name = params[:list_name].strip
  if list_name.size >= 1 && list_name.size <= 100
    session[:lists] << { name: params[:list_name], todos: [] }
    session[:success] = "The list has been created."
    redirect "/lists"
  else
    session[:error] = "List name mus be between 1 and 100 characters."
    erb :new_list, layout: :layout
  end
end
