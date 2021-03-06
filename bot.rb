require 'cinch'
require 'yaml'
require_relative 'plugins/ARG.rb'

config = YAML.load_file("config.yaml")

p config[:channels]

#Add the owner to the admins access list automatically.
config[:admins] << config[:owner]

#Export config as a global (for outside classes)
$config = config

#Modify the base user class to give us useful methods.
class Cinch::User
	def admin?
		$config[:admins].include?(self.nick)
	end

	def owner?
		$config[:owner].eql?(self.nick)
	end
end

bot = Cinch::Bot.new do
  configure do |c|
	c.nick = config[:nick]
	c.realname = config[:realname]
	c.user = "pi"
	c.server = config[:server]
	c.channels = config[:channels]
	c.plugins.plugins = [ARG]
	c.plugins.options[ARG] = {
		:password => config[:password],
		:db => config[:db],
		:owner => config[:owner],
		:admins => config[:admins]
   }
  end
end

bot.start