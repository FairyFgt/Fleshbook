class Before

    def initialize(db)
        @db = db        
    end

    def before_do(user_id)
        @db.execute("SELECT * FROM Users WHERE ID=?", user_id)
    end

end