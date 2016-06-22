require "gist_cleaner/version"
require 'httparty'

module GistCleaner
	def initialize()
  end

  def self.run()
  	puts "input username"
		username = gets.chomp
		if username.empty?
			puts "invalid username"
			return
		end
		puts "input password"
		password = gets.chomp
		if password.empty?
			puts "invalid password"
			return
		end

		puts 'enabled two-factor authentication? input optcode OR press the enter to continue'
		otpcode = gets.chomp
    @cleaner = Cleaner.new(username, password, otpcode)
		puts 'checking gists...'
		@cleaner.check_gists()
    @cleaner.delete_gists()
  end
end

class Cleaner
  include HTTParty

	def initialize(username, password, otpcode)
  	@username = username
  	@password = password
  	@otpcode = otpcode
  end

  def check_gists()
    self.class.base_uri 'https://api.github.com'
    self.class.basic_auth @username, @password
    if @otpcode.empty?
    	@gists = self.class.get("/users/#{@username}/gists", headers: {"User-Agent" => @username})

			if !@gists["message"].empty?
				abort @gists["message"]
			end

    	puts @gists
    	return
    	public_gists = @gists.select { |g| g["public"] == true }
			puts "you have #{public_gists.size} public gist"
    else
    	@gists = self.class.get("/users/#{@username}/gists", headers: {"User-Agent" => @username, "X-GitHub-OTP" => @otpcode})
    	public_gists = @gists.select { |g| g["public"] == true }
			puts "you have #{public_gists.size} public gist && #{@gists.size - public_gists.size} private gist"
    end
  end

  def delete_gists()
  	puts "clean gist 1.private 2.public 3.all. please input mode number: "
		clean_mode = gets.chomp.to_i
		if clean_mode < 1 || clean_mode > 3
			puts "invalid clean mode"
			return
		end
		puts 'enabled two-factor authentication? input optcode OR press the enter to continue'
		@otpcode = gets.chomp
		case clean_mode
		when 1
		  puts "clean private gists"
			i = 0
    	@gists.each do |g|
    		if g["public"] == false
    			self.delete_gists_action(g, i)
      		i = i + 1
    		end
    	end
		when 2
		  puts "clean public gists"
			i = 0
    	@gists.each do |g|
    		if g["public"] == true
    			self.delete_gists_action(g, i)
	     		i = i + 1
    		end
    	end
		when 3
		  puts "clean all gists"
		  i = 0
    	@gists.each do |g|
    		self.delete_gists_action(g, i)
      	i = i + 1
    	end
		else
			puts "invalid clean mode"
		end
	end

	def delete_gists_action(g, i)
		id = g["id"]
		puts "#{i+1}. DELETING: https://gist.github.com/#{@username}/#{id}"
		if @otpcode.empty?
			self.class.delete("/gists/#{id}", headers: {"User-Agent" => @username})
		else
			self.class.delete("/gists/#{id}", headers: {"User-Agent" => @username, "X-GitHub-OTP" => @otpcode})
		end
	end

end