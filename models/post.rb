class Post
    def initialize(db)
        @db = db
    end

    def get_content(id)
        @db.execute('SELECT * FROM posts
        WHERE posts.id = ?', id)[0]
    end

    def get_all()
        @db.execute('SELECT * FROM posts')
    end
end