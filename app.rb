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
    
    # Opens database and looks for an active session once upon rackup
    #
    # @db in this code is the opened database.db in the db folder
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

    # Logs out the current session
    #
    # Examples
    #  get('/logout/?')
    #  # => redirect('/')
    #
    # Redirects to index page
    get "/logout/?" do
        session.clear()
        redirect "/"
    end
    
    # Logs into account
    #
    # Examples
    #  post('login/?')
    #  # => redirect('/')
    #
    # Redirects to index page
    post "/login/?" do
        email = params["email"]
        password = params["password"]
        user = DBmanager.by_email(email)
        if user[:exists] == false || Pass_hash.validate(password, user[:data]['Password']) == false
            flash[:invalid_credentials] = "Invalid credentials."
            redirect "/login?email=#{email}"
            return
        end

        session[:user_id] = user[:data]['ID']
        redirect '/'
    end

    # The index page
    #
    # Examples
    #  get('/')
    #  posts all posts onto the index page
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

    # Posts a new post
    #
    # Examples
    #  post('/post/new')
    #  # => redirect('/')
    #
    # Redirect to index page
    post "/post/new" do
        title = params["title"]
        text = params["text"]
        picture_id = params["picture_id"]
        content = Post_content.new(@db)
        content.add_content(title, text,picture_id, @current_user["ID"])
        redirect '/'
    
    end

    # Displays the chosen post
    #
    # Examples
    #  get('/post/4')
    get '/post/:id' do |id|
        p = Post.new(@db)
        @current_post = p.get_content(id)
        
        slim :post
    end

    # Upvotes the post
    #
    # Examples
    #  post('/upvote/4')
    #  # => redirect('/')
    #
    # Redirects to index page
    post '/upvote/:id' do |id|
        if @current_user
            gbp = GBP.new(@db)           
            gbp.insert_gbp(id, @current_user["ID"])
            
        end
        redirect "/"
    end

    # Deletes a post, a function that has not been implemented yet to the fleshbook website
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

    # Registers the account
    #
    # Examples
    #  post('/register')
    #  # => redirect('/login')
    #
    # Redirects to the login page
    post "/register" do 
        email = params["email"]
        username = params["username"]
        password = params["password"]
        confirm_password = params["confirm password"]

        if password.length < 5
            flash[:insufficient_passwordlength] = "Your password has insufficient characters"
            redirect "/register?email=#{email}&username=#{username}"
            return
        end

        if password != confirm_password
            flash[:password_error] = "The passwords doesn't match."
            redirect "/register?email=#{email}&username=#{username}"
            return
        end
        
        if @db.execute("SELECT * FROM users WHERE Email=? OR Name=?",email, username).length != 0
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