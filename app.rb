require "sqlite3"

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
        user = DBManager.by_email(email)

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
        username = params["Name"]
        email =
        password =
        slim :register
    end


   

end