require "sqlite3"

class DBmanager


    def self.open_db
        if @db === nil
            @db = Sqlite3.database.new("db/database.db")
            @db.results_as_hash = true
        end
    end

    def self.by_email(email)
        open_db()
        db_result = @db.execute("SELECT * FROM users WHERE Email = ?", email.downcase()[0])
        if db_result == nil
            return {exists: false}
        else
            return {exists: true, data: db_result}
        end
    end

    def GBP(Name)
        @GBP = @db.execute("SELECT SUM(GBP) FROM users WHERE Name = ?", Name)
        if @GBP =< 0 
            @user_rank = "Normie"
        elsif @GBP < 100
            @user_rank = "Fleshling"
        elsif @GBP > 100
            @user_rank = "Steak"
        end

    end


    get "/user/:username" do |username|
        @current_user = @db.execute("SELECT * FROM users WHERE Name = ?", username)
        if @current_user.length == 0
            redirect "/error"
            return
        end
        slim :user_page 
    end

    get "/posts/img/:picture_id" do |picture_id|
        
    end

    get "/posts/:title" do |title|
        @current_post = @db.execute("SELECT * FROM posts WHERE Title = ?", title)
        if @current_post == 0
            redirect "/error"
            return
        end
    end

    

    get "/posts/:id" do
        @db = Sqlite3::database.new("db/database.db")
        @title = params["title"]
        @posts = @db.execute("SELECT * FROM posts WHERE id = ?;", id)
        slim :posts
    end




end