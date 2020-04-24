class GBP

    def initialize(db)
        @db = db
    end

    def get_gbp(id, user_id)
        @db.execute('SELECT GBP FROM posts WHERE id = ? AND user_id = ?', id, user_id)
    end

    def insert_gbp(id, user_id)
        @db.execute('INSERT INTO users (id, user_id) VALUES (?, ?)', id , user_id)
    end

end