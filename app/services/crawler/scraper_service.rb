module Crawler
  # scrape service
  class ScraperService
    class << self
      URL_HOST = 'http://quotes.toscrape.com'.freeze

      def search_quotes
        agent = Mechanize.new
        page_num = 1

        quote_paginator(agent, page_num, request_page(agent, page_num))
      end

      private

      def quote_paginator(agent, page_num, current_page)
        quotes = []
        loop do
          quote_selector = current_page.css('div.quote')

          data_page(quote_selector, quotes)

          break if page_ended?(quotes, page_num)

          page_num += 1
          current_page = request_page(agent, page_num)
        end

        quotes
      end

      def data_page(quote_selector, quotes)
        quote_selector.each do |quote|
          quotes.push(
            {
              quote: quote.css('span.text').text.tr('“”', ''),
              author: quote.css('small.author').text,
              tags: quote.css('div.tags a.tag').map(&:text)
            }
          )
        end
        quotes
      end

      def page_ended?(quotes, page_num)
        total_pages = (quotes.count / page_num).to_f.ceil

        total_pages == page_num
      end

      def request_page(agent, page_num)
        agent.get("#{URL_HOST}/page/#{page_num}/")
      end
    end
  end
end
