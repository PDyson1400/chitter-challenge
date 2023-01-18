require 'sinatra/base'
require 'sinatra/reloader'
require_relative 'lib/database_connection'
require_relative 'lib/chitpository'

DatabaseConnection.connect('chitter')

class Application < Sinatra::Base
    # This allows the app code to refresh
    # without having to restart the server.
    configure :development do
        register Sinatra::Reloader
        also_reload 'lib/chitpository'
    end

    get '/' do
        @repo = Chitpository.new
        @error = nil
        return erb(:home_page)
    end

    get '/rev' do
        @repo = Chitpository.new
        @error = nil
        return erb(:home_page_rev)
    end

    post '/' do
        if (params[:title] == nil) && (params[:username] != nil && params[:password] != nil)
            @repo = Chitpository.new
            result = @repo.signin(params[:username], params[:password])
            if result == "Username or Password is incorrect"
                @error = result
            else
                @error = nil
            end
            
            return erb(:home_page)
        elsif (params[:username] == nil || params[:password] == nil) && (params[:title] != nil)
            @repo = Chitpository.new
            peep = Peep.new
            peep.title = params[:title]
            peep.content = params[:content]
            peep.time = Time.now.to_s.split(" +")[0]
            @repo.post(peep)

            return erb(:home_page)
        else
            return erb(:home_page)
        end
    end

    get '/sign_in' do
        @error = nil
        return erb(:sign_in)
    end

    post '/sign_in' do
        repo = Chitpository.new
        result = repo.signup(params[:username], params[:password], params[:name], params[:email])
        @error = result

        return erb(:sign_in)
    end

    get '/sign_in/sign_up' do
        return erb(:sign_up)
    end

    get '/sign_out' do
        @repo = Chitpository.new
        @repo.signout
        return erb(:sign_out)
    end

    get '/post' do
        @repo = Chitpository.new
        return erb(:post)
    end

    get '/peep/:id' do
        repo = Chitpository.new
        @peep = repo.find_peep(params[:id])
        @username = repo.username(@peep.user_id)
        return erb(:details)
    end
end