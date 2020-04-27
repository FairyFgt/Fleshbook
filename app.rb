require "sqlite3"
require "rack-flash"
require_relative "models/db_manager"
require_relative "models/pass_cryptor"
require_relative "models/post_new"
require_relative "models/post"
require_relative "models/register"
require_relative "models/before_do"
require_relative "models/gbp"


class Fleshbook < Sinatra::Base

    enable :sessions
    use Rack::Flash
    
    
    before do
        @db = SQLite3::Database.new('db/database.db')
        @db.results_as_hash = true
        if session[:user_id]
            query = Before.new(@db)
            query = query.before_do(session[:user_id])
            if query.length != 0
                @current_user = query[0]
            end
        end
    end

    get "/login/?" do
        slim :login
    end

    get "/logout/?" do
        session.clear()
        redirect "/"
    end
    

    post "/login/?" do
        email = params["email"]
        password = params["password"]
        user = DBmanager.by_email(email)
        if user[:exists] == false || Pass_hash.validate(password, user[:data]['Password']) == false
            # redirect "/login?status=invalid_credentials"
            flash[:invalid_credentials] = "Invalid credentials."
            redirect "/login?email=#{email}"
            return
        end

        session[:user_id] = user[:data]['ID']
        redirect '/'
    end

    get "/" do
        p = Post.new(@db)
        @result = p.get_all()
        slim :collective
    end

    get "/post/new/?" do
        if @current_user
            slim :post_new
        end
    end

    
    post "/post/new" do
        title = params["title"]
        text = params["text"]
        picture_id = params["picture_id"]
        content = Post_content.new(@db)
        content.add_content(title, text,picture_id, @current_user["ID"])
        redirect '/'
    
    end


    get '/post/:id' do |id|
       # @current_post = @db.execute('SELECT * FROM posts WHERE id = ?', id)
        p = Post.new(@db)
        @current_post = p.get_content(id)
        @tot_GBP = @db.execute('SELECT GBP FROM posts WHERE id = ?', id)
        slim :post
    end

    post '/upvote/:id' do |id|
        if @current_user
            gbp = GBP.new(@db)           
            gbp.insert_gbp(id, @current_user["ID"])
            
        end
        redirect "/"
    end

    post "/delete/" do
       post = @db.execute('SELECT user_id FROM posts WHERE id = ?', params["id"])[0]
        if @current_user && (post['User_id'] == @current_user['ID'] || @current_user['admin'] == "true")
            @db.execute('DELETE FROM posts WHERE id = ?', params["id"])
        end
        redirect '/'
        return
    end

    def loggedin?()
        if session[:user_id]
            redirect "/"
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

        if password.length < 5
            # redirect "/register?status=insufficient_passwordlength"
            flash[:insufficient_passwordlength] = "Your password has insufficient characters"
            redirect "/register?email=#{email}&username=#{username}"
            return
        end

        if password != confirm_password
            # redirect "/register?status=password_error"
            flash[:password_error] = "The passwords doesn't match."
            redirect "/register?email=#{email}&username=#{username}"
            return
        end
        
        if @db.execute("SELECT * FROM users WHERE Email=? OR Name=?",email, username).length != 0
            # redirect"/register?status=taken_account"
            flash[:taken_account] = "That username or email is taken."
            redirect "/register?"
            return
        end
        r = Register.new(@db)
        r.register_credentials(email, username, password)
        redirect "/login"

    end

    get "/register/?" do
        slim :register
    end

end