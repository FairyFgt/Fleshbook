require "bcrypt"

class Passwordhash

    def self.create(password)
        BCrypt::password.create(password)
    end

    def self.validate(password, hash)
        BCrypt::Password.new(hash) == pasword
        
    end

end