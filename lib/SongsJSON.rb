class SongsJSON
  require 'cgi'
  require 'net/http'
  require 'json'

  class << self
    attr_accessor :song_list

    def decode(location)
      string    = location[1..-1]
      col       = location[0].to_i
      row       = (string.length.to_f / col).floor
      remainder = string.length % col
      address   = [[nil]*col]*(row+1)
      sizes = [row+1] * remainder + [row] * (col - remainder)
      pos = 0
      sizes.each_with_index { |size, i|
        size.times { |index| address[col * index + i] = string[pos + index] }
        pos += size
      }
      address = CGI::unescape(address.join).gsub('^', '0')
    end

    def build_from_collect collect_id
      collect_json = Net::HTTP.get(URI.parse("http://www.xiami.com/song/playlist/id/#{collect_id}/type/3/cat/json"))
      tracks = JSON.parse(collect_json)["data"]["trackList"]
      songs = []
      tracks.each do |t|
        song = {
          title: t["title"],
          artist: t["artist"],
          album: t["album_name"],
          cover: t["pic"].gsub('_1.jpg','_2.jpg'),
          mp3: decode(t["location"]),
          ogg: ""
        }
        songs << song
      end
      str = "acceptSongs({\"d\":#{songs.to_json}});"
    rescue 
      p $!
    end

  end

end