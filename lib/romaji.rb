module Romaji
  def self.for(origin)
    query_string = origin.gsub(/\n/, ",")
    url = "http://translate.google.com/translate_a/single?client=t&sl=ja&tl=en&hl=zh-CN&dt=bd&dt=ex&dt=ld&dt=md&dt=qc&dt=rw&dt=rm&dt=ss&dt=t&dt=at&ie=UTF-8&oe=UTF-8&prev=bh&ssel=0&tsel=0"
    result = Net::HTTP.post_form(URI(url), {:q=>query_string}).body
    romaji = /\[,,,"(.+)"\]\],,/.match(result)[1].force_encoding(Encoding::UTF_8)
    romaji.gsub!(/ō/, 'ou')
    romaji.gsub!(/ī/, 'ii')
    romaji.gsub!(/,\s?/, "\n")
    origin.split(/\n/).zip(romaji.split(/\n/))
  end
end