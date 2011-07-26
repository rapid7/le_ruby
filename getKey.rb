#!/usr/bin/env ruby
# coding: utf-8

#
# Logentries Ruby monitoring agent
# Copyright 2010,2011 Logentries, Jlizard
# Mark Lacomber <marklacomber@gmail.com>
#

require 'rubygems'
require 'net/https'
require 'net/http'

def die(message)
	puts message
	exit(1)
end

begin
	require 'json'
rescue LoadError
	die("Please Install Json gem to use this script")
end

begin
	require 'openssl'
rescue LoadError
	die("Please Install openssl gem to use this script")
end

def obtainKey
		
	print "\nUsername: "
	username = $stdin.gets.chomp

	print "\nPassword: "
	
	begin
		system "stty -echo"
		password = $stdin.gets.chomp
		print "\n"
	ensure
		system "stty echo"
	end

	http = Net::HTTP.new('logentries.com', 443)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	cred = sprintf("username=%s&password=%s", username, password)

	begin
		resp = http.post('/agent/user-key/', cred, {'Referer' => 'https://logentries.com/login/'})
	rescue OpenSSL::SSL::SSLError
		die("Please Ensure openssl gem is installed to use the script")
	end

	if resp.message == "OK"
		data = JSON.parse(resp.body)

		user_key = data["user_key"]

		puts user_key

		exit(0)
	else
		die("Incorrect details. Please Try Again")
	end
end

def register(host = 'Heroku', file = 'Heroku.log')

	print "\nUsername: "
	username = $stdin.gets.chomp

	print "\nPassword: "
	
	begin
		system "stty -echo"
		password = $stdin.gets.chomp
		print "\n"
	ensure
		system "stty echo"
	end

	http = Net::HTTP.new('logentries.com', 443)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	cred = sprintf("username=%s&password=%s", username, password)

	begin
		resp = http.post('/agent/user-key/', cred, {'Referer' => 'https://logentries.com/login/'})
	rescue OpenSSL::SSL::SSLError
		die("Please Ensure openssl gem is installed to use the script")
	end

	if resp.message != "OK"
		die("Incorrect details. Please Try Again")
	end
	
	data = JSON.parse(resp.body)

	user_key = data["user_key"]

	request = sprintf("distver=hero&name=%s&distname=Debian&hostname=Heroku&request=register&system=Linux&user_key=%s", host, user_key)
	
	http = Net::HTTP.new('api.logentries.com', 443)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	begin
   		resp = http.post2('/', request)
	rescue OpenSSL::SSL::SSLError
		die("Please Ensure openssl gem is installed to use the script")
	end

	data = JSON.parse(resp.body)

	host_key = data['host_key']

	full = sprintf("host_key=%s&name=%s&user_key=%s&request=new_log&filename=%s&follow=true&type=""", host_key, file, user_key, file)

	begin
		resp, data = http.post2('/', full)
	rescue OpenSSL::SSL::SSLError
		die("Please Ensure openssl gem is installed to use the script")
	end

	if resp.message != "OK"
		die("Incorrect details. Please Try Again")
	end

	puts resp.message

	exit(0)
end

def printUsage
	puts "\nUsage: ruby getKey.rb [options] <parameter(s)>"
	puts "\nOptions:\t--key\t\t\t\tRetrieve user key"
	puts "          \t--register <parameter(s)>\tCreate Host and LogFile on Logentries"
	puts "		--help\t\t\t\tShow the current screen"
	puts "\nParameters for  --register:"
	puts "\t\t\t-h Host(Optional)\tName of Host to be created, else Default Host 'Heroku' will be used"
	puts "\t\t\t-l Log(Optional)\tName of Log to be created, else Default Log 'Heroku.log' will be used"
end

unless ARGV.length >= 1
	printUsage
	exit
end      

if ARGV[0] == "--key"
	obtainKey
	exit(0)
end

if ARGV[0] == "--register"
	if ARGV.length == 1
		register
	elsif ARGV.length == 2
		printUsage
		exit(1)
	elsif ARGV.length == 3
		if ARGV[1] == '-h'
			register(ARGV[2], 'Heroku.log')
			exit(0)
		elsif ARGV[1] == '-l'
			register('Heroku', ARGV[2])
			exit(0)
		else
			printUsage
			exit(1)
		end
	elsif ARGV.length == 4
		printUsage
		exit(1)
	elsif ARGV.length == 5
		if ARGV[1] == '-h' and ARGV[3] == '-l'
			register(ARGV[2], ARGV[4])
			exit(0)
		elsif ARGV[1] == '-l' and ARGV[3] == '-h'
			register(ARGV[4], ARGV[2])
			exit(0)
		else
			printUsage
			exit(1)
		end
	else
		printUsage
		exit(1)
	end
end

if ARGV[0] == "--help"
	printUsage
	exit(0)
else
	printUsage
	exit(1)
end



