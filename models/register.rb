class Register

    def initialize(db)
        @db = db
    end

    def register_credentials(email, username, password)
        @db.execute("INSERT INTO users (Email,Name,Password) VALUES(?,?,?)",email,username,Pass_hash.create(password))
    end

end
