class Post
    def initialize(db)
        @db = db
    end

    #Public: Extract all data from posts where the post is specified
    #
    #Examples:
    # get_content(4)
    # # => [4,0,null, "text", title,14]
    #
    # Returns array in form as a post
    def get_content(id)
        @db.execute('SELECT * FROM posts
        WHERE posts.id = ?', id)[0]
    end

    #Public: Extract all data from posts
    #
    #Examples:
    # get_all()
    # # => everything from posts
    #
    # Returns as array in form of posts
    def get_all()
        @db.execute('SELECT * FROM posts')
    end
end