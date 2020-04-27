class Post
    def initialize(db)
        @db = db
    
    end

    def get_content(id)
        @db.execute('SELECT posts.*, count(post_gbp.ID) AS gbp FROM posts
        LEFT JOIN post_gbp
        ON posts.id = post_gbp.post_id
        WHERE posts.id = ?', id)[0]
    end

    def get_all()
        @db.execute('SELECT * FROM posts
        LEFT JOIN post_gbp
        ON posts.id = post_gbp.post_id')
    end
end