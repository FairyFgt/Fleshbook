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