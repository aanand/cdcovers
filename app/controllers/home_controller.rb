require 'open-uri'
require 'hpricot'

class HomeController < ApplicationController
  layout 'default'

  def index
    @wikipedia_response = open("http://en.wikipedia.org/wiki/Special:Random")
    @wikipedia  = Hpricot(@wikipedia_response)
    @quotations = Hpricot(open("http://www.quotationspage.com/random.php3"))
    @flickr     = Hpricot(open("http://www.flickr.com/explore/interesting/7days"))

    @band_name = @wikipedia.search("title").inner_text.sub(/ - [^-]*$/, '').sub(/\([^\)]+\)$/, '')
    @wikipedia_url = @wikipedia_response.base_uri.to_s

    run = "[^ \\-.,;:!?'\"]+"
    regex = Regexp.new("(#{run}('#{run})?)")

    @quote             = @quotations.search("dt.quote:last").inner_text.strip
    @author            = @quotations.search("dd.author:last b a").inner_text.strip

    @album_title_words = @quote.downcase.scan(regex).collect { |m| m.first }[-5..-1]
    @first_word        = @album_title_words.first
    @all_words         = @album_title_words.join(" ")

    @image_link     = @flickr.search("td.Photo a")[3]
    @image_page_url = @image_link.get_attribute("href")
    @image_url      = @image_link.search("img").first.get_attribute("src")
  end
end

