class SearchController < ApplicationController
  def ping
    render json: @url = URI.encode("https://ja.wikipedia.org/wiki/#{params[:target_keyword]}")
  end

  def relational_keywords
    target_url = "https://ja.wikipedia.org/wiki/#{URI.encode(params[:target_keyword])}"
    charset = nil
    html = open(target_url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    doc = Nokogiri::HTML.parse(html, nil, charset)

    keywords = {}
    node = nil

    doc.xpath('//h2/span').map do |h2_inner_span|
      node = h2_inner_span.parent.next_element if h2_inner_span.content == '関連項目'
    end

    while node.name != 'ul'
      node = node.next_element
    end

    node.css('li > a').each do |a|
      relational_keyword = a.attributes['title'].value
      relational_keyword_url = a.attributes['href'].value
      keywords[relational_keyword] = 'https://ja.wikipedia.org' + relational_keyword_url
    end

    @keywords = keywords
    render json: @keywords
  end

end
