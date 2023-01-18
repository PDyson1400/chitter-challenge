require_relative './peeps'
require_relative './users'

class Chitpository
    def initialize
        sql = "SELECT current_user_id FROM current WHERE id = 1;"
        user = DatabaseConnection.exec_params(sql, [])[0]["current_user_id"].to_i
        @current_user = user
    end

    def find_peep(id)
        sql = "SELECT * FROM peeps WHERE id = $1;"
        params = [id]
        post = DatabaseConnection.exec_params(sql, params)[0]

        peep = Peep.new
        peep.id = post['id']
        peep.title = post['title']
        peep.content = post['content']
        peep.time = post['time']
        peep.user_id = post['user_id']

        return peep
    end

    def current_user
        return @current_user
    end

    def current_username
        sql = "SELECT username FROM users WHERE id = $1;"
        params = [@current_user]
        begin
            result = DatabaseConnection.exec_params(sql, params)[0]
        rescue
            return "Nil"
        else
            return result['username']
        end
    end

    def user_exist?(username)
        sql = "SELECT username FROM users WHERE username = $1;"
        params = [username]

        begin
            result = DatabaseConnection.exec_params(sql, params)[0]
        rescue
            return false
        else
            return true
        end
    end

    def username(id)
        sql = "SELECT username FROM users WHERE id = $1;"
        params = [id]
        name = DatabaseConnection.exec_params(sql, params)[0]

        return name['username']
    end

    def email_exist?(email)
        sql = "SELECT email FROM users WHERE email = $1;"
        params = [email]

        begin
            result = DatabaseConnection.exec_params(sql, params)[0]
        rescue
            return false
        else
            return true
        end
    end

    def password_strong?(password)
        if password.match(/[!*£$@?()&]/) && password.match(/[a-z]{1,}/) && password.match(/[0-9]{1,}/) && password.length >= 6
            return true
        else
            return false
        end
    end

    def email_match?(email)
        if email.match(/.+@.+\.com/)
            return true
        else
            return false
        end
    end

    def find_userid(username, password)
        sql = "SELECT id FROM users WHERE username = $1 AND password = $2;"
        params = [username, password]

        begin
            result = DatabaseConnection.exec_params(sql, params)[0]
        rescue
            return false
        else
            return result['id'].to_i
        end
    end

    def post(peep)
        sql = "INSERT INTO peeps (title, content, time, user_id) VALUES ($1, $2, $3, $4);"
        if peep.title.match(/[\/\\<>]/)
            peep.title = "stinky"
        end
        if peep.content.match(/[\/\\<>]/)
            peep.content = "stinky"
        end
        params = [peep.title, peep.content, peep.time, @current_user]
        DatabaseConnection.exec_params(sql, params)
    end

    def delete(id)
        sql = "DELETE FROM peeps WHERE id = $1;"
        params = [id]
        DatabaseConnection.exec_params(sql, params)
    end

    def all_peeps
        sql = 'SELECT * FROM peeps;'
        result = DatabaseConnection.exec_params(sql, [])

        peeplist = []

        result.each do |post|
            peep = Peep.new
            peep.id = post['id']
            peep.title = post['title']
            peep.content = post['content']
            peep.time = post['time']
            peep.user_id = post['user_id']

            peeplist.push(peep)
        end

        return peeplist
    end

    def chrono_peeps
        sql = 'SELECT * FROM peeps ORDER BY time ASC;'
        result = DatabaseConnection.exec_params(sql, [])

        peeplist = []

        result.each do |post|
            peep = Peep.new
            peep.id = post['id']
            peep.title = post['title']
            peep.content = post['content']
            peep.time = post['time']
            peep.user_id = post['user_id']

            peeplist.push(peep)
        end

        return peeplist
    end

    def time(id)
        result = find_peep(id)
        return result.time
    end

    def signup(username, password, name, email)
        if username.match(/[\/\\<>;]/)
            username = "stinky"
        end
        if password.match(/[\/\\<>;]/)
            password = "stinky"
        end
        if name.match(/[\/\\<>;]/)
            name = "stinky"
        end
        if email.match(/[\/\\<>;]/)
            email = "stinky"
        end
        if password_strong?(password) == false
            return "Password is too weak"
        elsif user_exist?(username) == true
            return "Username is unavailable"
        elsif email_exist?(email) == true
            return "Email is unavailable"
        elsif email_match?(email) == false
            return "Enter a proper email"
        else
            sql = "INSERT INTO users (username, password, name, email) VALUES ($1, $2, $3, $4);"
            params = [username, encrypt(password), name, email]
            DatabaseConnection.exec_params(sql, params)
            return "Sign up successful"
        end
    end

    def signin(username, password)
        if username.match(/[\/\\<>]/)
            username = "stinky"
        end
        if password.match(/[\/\\<>]/)
            password = "stinky"
        end
        if @current_user != 0 || find_userid(username, encrypt(password)) == false
            return "Username or Password is incorrect"
        else
            sql = "UPDATE current SET current_user_id = $1 WHERE id = 1;"
            params = [find_userid(username, encrypt(password))]
            DatabaseConnection.exec_params(sql, params)
            
            @current_user = find_userid(username, encrypt(password))

            return "Sign in successful"
        end
    end

    def signout
        sql = "UPDATE current SET current_user_id = 0 WHERE id = 1;"
        DatabaseConnection.exec_params(sql, [])
        @current_user = 0
        return "Sign out successful"
    end

    def sequence_solve(character, i=0, dir=0)
        seq_char = "gqxaeryzovkcmsjfruhipdblnt"
        seq_char_up = "PZDVYRQGKUNBCHMOXWTJLSFEIA"
        seq_num = "4651827930"
        seq_spec = "!*£$@?()&?"
        
        if dir == 0
            if seq_char.include?(character)
                index = seq_char.index(character)
                index += i
                if index >= seq_char.length
                    index -= seq_char.length
                end
                return seq_char[index]
            elsif seq_char_up.include?(character)
                index = seq_char_up.index(character)
                index += i
                if index >= seq_char_up.length
                    index -= seq_char_up.length
                end
                return seq_char_up[index]
            elsif seq_num.include?(character)
                index = seq_num.index(character)
                index += i
                if index >= seq_num.length
                    index -= seq_num.length
                end
                return seq_num[index]
            elsif seq_spec.include?(character)
                index = seq_spec.index(character)
                index += i
                if index >= seq_spec.length
                    index -= seq_spec.length
                end
                return seq_spec[index]
            end
        elsif dir == 1
            if seq_char.include?(character)
                index = seq_char.index(character)
                index -= i
                if index < 0
                    index += seq_char.length
                end
                return seq_char[index]
            elsif seq_char_up.include?(character)
                index = seq_char_up.index(character)
                index -= i
                if index < 0
                    index += seq_char_up.length
                end
                return seq_char[index]
            elsif seq_num.include?(character)
                index = seq_num.index(character)
                index -= i
                if index < 0
                    index += seq_num.length
                end
                return seq_num[index]
            elsif seq_spec.include?(character)
                index = seq_spec.index(character)
                index -= i
                if index < 0
                    index += seq_spec.length
                end
                return seq_spec[index]
            end
        end
    end

    def encrypt(password)
        new_pw = ""
        arr = password.split("")
        i = 1
        arr.each do |letter|
            char = sequence_solve(letter, i, 0)
            if char != nil
                new_pw += char
            end
            i += 1
        end

        return new_pw
    end

    def decrypt(password)
        new_pw = ""
        arr = password.split("")
        i = 1
        arr.each do |letter|
            char = sequence_solve(letter, i, 1)
            if char != nil
                new_pw += char
            end
            i += 1
        end

        return new_pw
    end
end