module Crawler
  class ScraperService
    URL_HOST = 'http://quotes.toscrape.com'
    
    def self.parser       
      agent = Mechanize.new
      
      quotes = []
      page_num = 1
      page = pager(agent, page_num)
        
      loop do
        full_page = page.css('div.quote')
        full_page.each do |quote|
          quotes.push({
              quote: quote.css('span.text').text.tr('“”', ''),
              author: quote.css('small.author').text,
              tags: quote.css('div.tags a.tag').map(&:text),
          })
        end
        
        total_pages = (quotes.count.to_f / page_num.to_f).ceil

        break if page_num == total_pages

        page_num += 1
        page = agent.get("#{URL_HOST}/page/#{page_num}/")
      end
      quotes
    end

    def self.pager(agent, page_num)
      agent.get("#{URL_HOST}/page/#{page_num}/")
    end
  end
end