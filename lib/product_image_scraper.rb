require 'open-uri'
require 'nokogiri'

class ProductImageScraper
  def self.extract_image(url)
    html = URI.open(url, "User-Agent" => "Mozilla/5.0").read
    doc = Nokogiri::HTML(html)

    # Example selectors – this varies by site!
    img = doc.at_css('img')

    return img['src'] if img

    nil
  rescue => e
    Rails.logger.error "Image scrape failed: #{e.message}"
    nil
  end
end
