module Crawler
  class ScraperService
    URL_HOST = 'http://quotes.toscrape.com'
    
    def self.parser       
      agent = Mechanize.new
      
      quotes = []
      page = agent.get("#{URL_HOST}/page/1/")
      paginator = page.at('ul.pager li.next a').attributes['href'].value
      
      page_num = 1

      while page_num <= 10
        full_page = page.css('div.quote')
        full_page.each do |quote|
          quotes.push({
              quote: quote.css('span.text').text,
              author: quote.css('small.author').text,
              tags: quote.css('div.tags a.tag').map(&:text),
          })
        end
        
        binding.pry
        page_num += 1
        page = agent.get("#{URL_HOST}/page/#{page_num}/")
      end
      quotes
    end
  end
end