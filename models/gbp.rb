class GBP

    def initialize(db)
        @db = db
    end

    def get_gbp(id)
        @db.execute('SELECT count(GBP) AS GBP WHERE id = ?', id)
    end

    def insert_gbp(id, user_id)
      if  @db.execute('SELECT ID WHERE post_id = ? AND user_id = ?', id, user_id).length == 0
        @db.execute('INSERT INTO post_gbp (User_id, Post_id) VALUES (?, ?)',user_id, id)
      end
        #@db.execute('UPDATE posts SET GBP = GBP + 1 WHERE id = ?', id)
        #@db.execute('INSERT INTO users (id, user_id) VALUES (?, ?)', id , user_id)
    end

end