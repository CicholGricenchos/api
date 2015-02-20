#encoding : utf-8
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
require 'sinatra'

def jsonp(callback, data)
  if callback.nil?
    data
  else
    "#{callback}(#{data})"
  end
end

before do
  content_type 'text/javascript'
end

get '/song_list' do
  content_type 'text/javascript'
  SongsJSON.song_list ||= SongsJSON.build_from_collect 37876152
end

get '/reload_list' do 
  content_type 'text/javascript'
  SongsJSON.song_list = SongsJSON.build_from_collect 37876152
end

get '/romaji' do
  result = Romaji.for(params[:q]).flatten.to_json
  jsonp(params[:callback], result)
end