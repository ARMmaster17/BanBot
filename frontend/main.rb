#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'slim'
require 'rest-client'
require 'json'
require 'rack-flash'
require_relative 'lib/groupme'
require_relative 'lib/ban_finder'
require_relative 'models/chats'
require_relative 'models/users'

set :port, ENV['PORT'] || 8080
set :bind, ENV['IP'] || '0.0.0.0'

helpers do
  def login?
      if session[:auth].nil? || session[:auth] == false
          return false
      else
        return true
      end
  end
end

##
# Index page of site.
get '/' do
   slim :index
end

post '/auth/login' do
  usrs = Users.find_by(username: params[:uname], password: params[:pword]).first
  if usrs.nil?
    # User did not authenticate correctly.
    redirect '/'
  else
    # Fix token
    session[:auth] = true
    session[:uname] = usrs.username
    redirect '/dashboard'
  end
end

get '/dashboard' do
    if !login?
      redirect '/'
    end
    @groups = Chats.all
    @badwords = Badwords.all
    slim :dashboard
end

post 'api/v1/data/chats' do
    if !login?
        redirect '/'
    end
  data = Chats.create(bot_id: params[:bot_id], group_id: params[:group_id], admin_username: params[:admin_username])
end

post 'api/v1/data/badwords' do
    if !login?
        redirect '/'
    end
  data = Badwords.create(group_id: params[:group_id], word: params[:word])
end

post '/api/v1/groupme' do
    request.body.rewind
    inbound_payload = JSON.parse(request.body.read)
    inbound_message = inbound_payload['text']
    inbound_sender = inbound_payload['name']
    inbound_group = inbound_payload['group_id']
    if inbound_payload['sender_type'].eql?('user')
        testable = BanFinder.find_bannable(inbound_message, inbound_group)
        if !testable.eql?('NOWORDSFOUND')
          # Found a bad word
          payload = 'Careful @' + inbound_sender + ". You used the bad word '" + testable + "'. Use it again and you'll get a ban hammer to the face!"
          GroupMe.send(inbound_sender, payload, Chats.find_by(group_id: inbound_group).first.bot_id)
        end
    end
end