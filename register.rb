#!/usr/bin/env ruby
# coding: utf-8

#
# Logentries Ruby monitoring agent
# Copyright 2010,2011 Logentries, Jlizard
# Mark Lacomber <marklacomber@gmail.com>
#
LE_VERSION = "1.1"

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

def register()

	print "\nUsername: "
	username = $stdin.gets.chomp

	print "Password: "

	begin
		system "stty -echo"
		password = $stdin.gets.chomp
		print "\n"
	ensure
		system "stty echo"
	end
	print "\n"

	puts "Authenticating...please wait a moment\n"

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
		die("Incorrect Login Details. Please Try Again")
	end
	
	data = JSON.parse(resp.body)

	user_key = data["user_key"]

	print "Name of host you wish to create: "
	host = $stdin.gets.chomp
	puts ""

	print "Name of logfile you wish to create: "
	logFile = $stdin.gets.chomp

	request = sprintf("distver=hero&name=%s&distname=Debian&hostname=%s&request=register&system=Linux&user_key=%s", host, host, user_key)
	
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

	full = sprintf("host_key=%s&name=%s&user_key=%s&request=new_log&filename=%s&follow=true&type=""", host_key, logFile, user_key, logFile)

	begin
		resp, data = http.post2('/', full)
	rescue OpenSSL::SSL::SSLError
		die("Please Ensure openssl gem is installed to use the script")
	end

	if resp.message != "OK"
		die("Incorrect response. Please Try Again")
	end

	endMessage = sprintf("Successfully Created Host: '%s' and LogFile: '%s' on Logentries\n\n", host, logFile)
	puts endMessage

	puts sprintf("Please use the following format for LOGENTRIES_LOCATION in your config: '%s/%s'", host, logFile)

	exit(0)
end

def printUsage
	puts "\nUsage: ruby register.rb"
	exit(0)
end      

puts "\nLogentries Command-Line Tool"

register
