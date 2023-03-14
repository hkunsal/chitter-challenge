require 'sinatra'
require "sinatra/reloader"
require 'sinatra/base'
require_relative 'lib/database_connection'
require_relative 'lib/maker_repository'
require_relative 'lib/peep_repository'

DatabaseConnection.connect

class Application < Sinatra::Base 
  configure :development do
    register Sinatra::Reloader
  end

  helpers do
    def current_user
      @current_user ||= MakerRepository.new.find(session[:maker_id]) if session[:maker_id]
    end
  end

  get '/' do
    return erb(:index)
  end

  get '/peeps' do
    repo = PeepRepository.new
    @peeps = repo.all_with_maker_username
    erb(:peeps)
  end

  get '/signup' do
    return erb(:signup)
  end

  post '/signup' do
    repo = MakerRepository.new
    username = params[:username]
    password = params[:password]
    name = params[:name]
    email = params[:email]
  
    # check if username already exists
    if repo.find_by_username(username)
      # handle error
      return "Username already exists"
    end
  
    # create new maker
    new_maker = Maker.new(username: username, password: password, name: name, email: email)

    # save maker to database
    repo.create(new_maker)
  
    # redirect to login page
    return erb(:login)
  end
  

  get '/login' do
    @error_message = session.delete(:error_message)
    erb(:login)
  end
  

  post '/login' do
    session.clear
    maker_repo = MakerRepository.new
    maker = maker_repo.find_by_username(params[:username])
    
    if maker && maker.password == params[:password]
      session[:maker_id] = maker.id
      return erb(:new_peep)
    else
      session[:error_message] = 'Invalid username or password'
      return erb(:login_fail)
    end
  end
  
  get '/peeps/new' do
    if current_user
      erb(:new_peep)
    else
      session[:error_message] = 'You must be logged in to post a peep'
      redirect '/login'
    end
  end
  
  
  post '/peeps' do
    content = params[:content]
    maker_id = params[:maker_id]
  
    new_peep = Peep.new
    new_peep.content = content
    new_peep.created_at = Time.now.to_date
    new_peep.maker_id = maker_id

    repo = PeepRepository.new
    new_peep.maker_username = repo.get_maker_username(maker_id)
    repo.create(new_peep)

    redirect '/peeps'
  end 
end
