require 'cinch'
require 'yaml'

DB_FOLDER = "plugins/db"
SITREP = "http://j.mp/ONIsitrp"
POTATO_URL = "http://halo.stckr.co.uk/media/img/halo5-potato.png"

class ARG
	include Cinch::Plugin

	hook :pre, method: :load_db

	match /ask .+\?$/i, method: :ask
	match /sitrep/i, method: :sitrep
	match /potato/i, method: :potato
	match /arg .+/i, method: :arg

	def load_db(m)
		#Probably want to figure out a way of loading this just once.
		@responses = YAML.load_file("#{DB_FOLDER}/ask.yaml")
		@arg = YAML.load_file("#{DB_FOLDER}/arg.yaml")
	end

	def ask(m)
		m.reply "#{@responses[rand(0..@responses.length)]}"
	end

	def sitrep(m)
		m.reply "//CLASSIFIED//TRUTH//SITREP - #{SITREP}"
	end

	def potato(m)
		m.reply "Hi, how are you holding up? Because I'm a potato - #{POTATO_URL}"
	end

	def arg(m)
		reply = @arg[m.message.downcase!.split(" ")[1]]
		m.reply reply.nil? ? @arg["help"].first : reply.first
	end

end