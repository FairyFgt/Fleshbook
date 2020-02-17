require "sqlite3"
require_relative "models/db_manager"
require_relative "models/pass_cryptor"

class Fleshbook < Sinatra::Base

    enable :sessions
    
    before do
        @db = SQLite3::Database.new('db/database.db')
    end

    get "/login/?" do
        slim :login
    end

    post "/login/?" do
        email = params["email"]
        password = params["password"]
        user = DBmanager.by_email(email)

        if @db.execute("SELECT ID FROM Users WHERE Email=? AND Password=?", email, password).length != 0
            redirect "/invalid_credentials"
        end
    end

    get "/" do 
        @result = @db.execute('SELECT * from posts')
        slim :index
    end


    get '/post/:id' do |id|
        @current_post = @db.execute('SELECT * FROM posts WHERE id = ?', id)
        @tot_GBP = @db.execute('SELECT GBP FROM posts WHERE id = ?', id)
        slim :post
    end

    post '/delete/:id' do |id|
        if current_user && current_user['admin'] == 'true'
            @db.execute('DELETE FROM posts WHERE id = ?', id)
        end
        redirect '/'
        return
    end

    def loggedin?()
        if session[:user_id]
            else
            redirect "/"
            return
        end
    end

    post "/register" do
        email = params["email"]
        username = params["username"]
        password = params["password"]
        confirm_password = params["confirm password"]

        if password != confirm_password
            redirect "/register"
            return
        end

        @db.execute("INSERT INTO users (Email,Name,Password) VALUES(?,?,?)",email,username,Pass_hash.create(password))

    end

    get "/register/?" do
        slim :register
    end

end