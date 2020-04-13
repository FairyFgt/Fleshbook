require "sqlite3"

class Post_content

    def initialize(db)
        @db = db    
    end

    def get_content(title, content)
        @db.execute('INSERT INTO posts (title, content) VALUES (?,?)', title, content)
    end
    
end
