require 'chitpository'

def reset_table
    seed_sql = File.read('spec/seeds_chitter.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter' })
    connection.exec(seed_sql)
end

RSpec.describe "chitpository testing" do
    before(:each) do 
        reset_table
    end

    context "seeing all messages" do
        it "should list all the message titles" do
            repo = Chitpository.new
            expect(repo.all_peeps.last.title).to eq "I have made a decision"
        end

        it "should be able to sort messages chronologically" do
            repo = Chitpository.new
            expect(repo.chrono_peeps.last.title).to eq "I have made a decision"
        end
    end

    context "finding a message from it's id" do
        it "when given an id should be able to pull details from the peep" do
            repo = Chitpository.new
            result = repo.find_peep(3)
            expect(result.title).to eq "Promotion!"
        end

        it "when given an id should be able to pull details from the peep" do
            repo = Chitpository.new
            result = repo.find_peep(5)
            expect(result.user_id).to eq "2"
        end
    end

    context "username exit already?" do
        it "should return true when it does exist" do
            repo = Chitpository.new
            expect(repo.user_exist?('Doug1234')).to eq true
        end

        it "should return false when it does not exist" do
            repo = Chitpository.new
            expect(repo.user_exist?('Doug')).to eq false
        end
    end

    context "finding user id" do
        it "finds the user when the username and password are correct" do
            repo = Chitpository.new
            result = repo.find_userid('Doug1234', 'Doug1234!')
            expect(result).to eq 1
        end

        it "returns false when the username is incorrect" do
            repo = Chitpository.new
            result = repo.find_userid('username', 'Doug1234!')
            expect(result).to eq false
        end

        it "does the same for passwords" do
            repo = Chitpository.new
            result = repo.find_userid('Doug1234', 'Doug1234')
            expect(result).to eq false
        end
    end

    context "posting a message" do
        it "should be able to post a message and then check it's posted" do
            repo = Chitpository.new
            repo.signin("Username", "Password4321?")
            peep = Peep.new
            peep.title = "Title"
            peep.content = "content"
            peep.time = "2022-10-12 20:14:32"

            repo.post(peep)

            expect(repo.all_peeps.last.title).to eq "Title"
        end

        it "should be able to delete a message once posted" do
            repo = Chitpository.new
            repo.signin("Doug1234", "Doug1234!")
            peep = Peep.new
            peep.title = "Title"
            peep.content = "content"
            peep.time = "2022-10-12 20:14:32"
            peep.user_id = 2

            repo.post(peep)

            repo.delete(7)

            expect(repo.all_peeps.last.title).to eq "I have made a decision"
        end

        it "should be able to display the time the message was posted" do
            repo = Chitpository.new
            expect(repo.time(5)).to eq "2022-07-03 19:22:18"
        end
    end

    context "signing in and signing up" do
        it "should deny you with a used username" do
            repo = Chitpository.new
            expect(repo.signup('Melody', '&231aa', 'Melody', 'Mels@gmail.com')).to eq "Username is unavailable"
        end

        it "should deny you with a used email" do
            repo = Chitpository.new
            expect(repo.signup('Mel', '&231aa', 'Melody', 'Mels@gmail.com')).to eq "Email is unavailable"
        end

        it "should deny you with a non-email" do
            repo = Chitpository.new
            expect(repo.signup("Christopher", "1234aa*", 'Chris', 'Chris.com')).to eq "Enter a proper email"
        end

        it "should deny you with a weak password" do
            repo = Chitpository.new
            expect(repo.signup("Christopher", "1234", 'Chris', 'Chris@topher.com')).to eq "Password is too weak"
        end
        
        it "should allow you to sign up, but only with an original username and a strong password" do
            repo = Chitpository.new
            expect(repo.signup("Christopher", "1234aa*", 'Chris', 'Chris@topher.com')).to eq "Sign up successful"
            expect(repo.user_exist?('Christopher')).to eq true
        end

        it "should display username or password is incorrect when it is" do
            repo = Chitpository.new
            repo.signup("Christopher", "1234aa*", 'Chris', 'Chris@topher.com')
            expect(repo.signin("Christopher", "123456")).to eq "Username or Password is incorrect"
        end

        it "should allow you to sign in after signing up" do
            repo = Chitpository.new
            repo.signup("Christopher", "1234aa*", 'Chris', 'Chris@topher.com')
            expect(repo.signin("Christopher", "1234aa*")).to eq "Sign in successful"
        end

        it "should allow you to sign out of chitter" do
            repo = Chitpository.new
            repo.signup("Christopher", "1234aa*", 'Chris', 'Chris@topher.com')
            repo.signin("Christopher", "1234aa*")
            expect(repo.signout).to eq "Sign out successful"
        end

        it "should allow you to sign out of chitter and back in" do
            repo = Chitpository.new
            repo.signup("Christopher", "1234aa*", 'Chris', 'Chris@topher.com')
            repo.signin("Christopher", "1234aa*")
            repo.signout
            expect(repo.signin("Christopher", "1234aa*")).to eq "Sign in successful"
        end

        it "should provide the correct user id" do
            repo = Chitpository.new
            repo.signin("Melody", "&231aa")
            expect(repo.current_user).to eq 3
        end

        it "once logged in should provide current username" do
            repo = Chitpository.new
            repo.signin("Melody", "&231aa")
            expect(repo.current_username).to eq "Melody"
        end

        it "if not logged in display Nil" do
            repo = Chitpository.new
            expect(repo.current_username).to eq "Nil"
        end
    end
end