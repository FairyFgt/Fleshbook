require "sqlite3"

class DBmanager


    def self.open_db
        if @db === nil
            @db = Sqlite3.database.new("db/database.db")
            @db.results_as_hash = true
        end
    end

    def self.by_email(email)
        open_db()
        db_result = @db.execute("SELECT * FROM users WHERE Email = ?", email.downcase()[0])
        if db_result == nil
            return {exists: false}
        else
            return {exists: true, data: db_result}
        end
    end

    def self.GBP(name)
        @GBP = @db.execute("SELECT SUM(GBP) FROM users WHERE Name = ?", name)
        if @GBP <= 0
            @user_rank = "Normie"
        elsif @GBP < 100
            @user_rank = "Fleshling"
        elsif @GBP > 100
            @user_rank = "Steak"
        end
    end
end