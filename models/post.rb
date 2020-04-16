class Post
    def initialize(db)
        @db = db
    
    end

    def get_content(id)
        @db.execute('SELECT * FROM posts WHERE id = ?', id)[0]
    end
end