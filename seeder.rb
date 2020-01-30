require "sqlite3"

class Seeder

    def self.seed!

        db = connect
        drop_tables(db)
        create_tables(db)
        populate_tables(db)

    end

    def self.connect

        SQLite3::Database.new 'DB/database.db'

    end

    def self.drop_tables(db)

        db.execute('DROP TABLE IF EXISTS users')
        db.execute('DROP TABLE IF EXISTS posts')
        db.execute('DROP TABLE IF EXISTS comments')

    end

    def self.create_tables(db)

        db.execute <<-SQL
            CREATE TABLE "users" (
                "Email"     TEXT NOT NULL UNIQUE NOCASE,
                "ID"        INTEGER PRIMARY KEY AUTOINCREMENT,
                "Name"      TEXT NOT NULL UNIQUE,
                "Password"  TEXT NOT NULL,
                "GBP"       INTEGER NOT NULL DEFAULT 0

            );
        SQL

        db.execute <<-SQL
            CREATE TABLE "comments" (
                "ID"        INTEGER PRIMARY KEY AUTOINCREMENT,
                "GBP"       INTEGER NOT NULL DEFAULT 0,
                "Parent_id" INTEGER,
                "Comment"   TEXT NOT NULL

            );
        SQL

        db.execute <<-SQL
            CREATE TABLE "posts" (
                "ID"         INTEGER PRIMARY KEY AUTOINCREMENT,
                "GBP"        INTEGER NOT NULL DEFAULT 0,
                "Picture_id" TEXT UNIQUE,
                "Text"       TEXT NOT NULL NOCASE,
                "Title"      TEXT NOT NULL NOCASE
            
            );
        SQL


    end

    def self.populate_tables(db)

        users = [
            
            {Email:"Jesper.storberg@fleshbook.br", Name: "JessGore420", Password: "asjhyujgvtyhujikhgvtyhuj", GBP:2},
            {Email:"Hungman@hotmail.se", Name: "Hungman", Password: "jvnknhjbhyujnhnb", GBP:-5},
            {Email:"Marcus_admaner", Name: "InnocentBoi99", Password: "bvcdrtyuikjmnb", GBP:56},
            {Email:"Potatolover@gmail.com", Name: "Hotp0tato", Password: "zsdertyuiol", GBP:5},
            {Email:"Weeb@weebmail.jp", Name: "Animelover69Weebz", Password: "xcvbnmkidearfj", GBP:-25},
            {Email:"Adam@adam.com", Name: "Adam", Password: "frtyuioladammnbv", GBP:3},
        ]

        comments = [
            {GBP: 3, Parent_id: nil, Comment: "Nice eyes on the floor" }
        ]

        posts = [
            {GBP: 5, Picture_id: "asdf2678fi7" Text: "This is my new decoration" Title: "Halloween" }
        ]

        users.each do |user| 
            db.execute("INSERT INTO users (Email, Name, Password, GBP) VALUES(?,?,?,?)", user[:Email].downcase(), user[:Name], user[:Password], :[:GBP])
        end   

        posts.each do |post|
            db.execute("INSERT INTO posts (GBP, Picture_id, Text, Title) VALUES(?,?,?,?)", post[:GBP], post[:Picture_id], post[:Text], post[:Title])
        end

        comments.each do |comment|
            db.execute("INSERT INTO comments (GBP, Parent_id, Comment) VALUES(?,?,?)", comment[:GBP], comment[:Parent_id], comment[:Comments])
        end
    end
end

Seeder.seed!