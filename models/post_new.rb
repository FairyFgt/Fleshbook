require "sqlite3"

class Post_content

    def initialize(db)
        @db = db    
    end

    def add_content(title, text, picture_id)
        @db.execute('INSERT INTO posts (title, text, picture_id) VALUES (?,?,?)', title, text, picture_id)
    end
    
end
