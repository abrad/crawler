require 'anemone'
require 'debugger'
require './page.rb'

class Sitemap
	def initialize(input_url, print_assets)
		@pages = []
		@asset_print = print_assets == "true" ? true : false

		Anemone.crawl(input_url) do |anemone|
  			titles = []
  			anemone.on_every_page do |page| 
  				# debugger
  				if find_page(page).nil?
	  				title    = ''
	  				title    = page.doc.at("title").inner_html rescue nil
	  				assets   = page.doc.css('img').map{|e| e.attributes["src"].value if e.attributes["src"] != nil}.compact
	  				new_page = Page.new(page.url, page.referer, title, page.depth, assets)
	  				parent   = find_parent_page(new_page)
	  				if !parent.nil?
	  					parent.children_pages << new_page
	  				else
	  					@pages << new_page
	  				end
	  			end
  			end
  			anemone.after_crawl { @pages.map {|p| puts p.print("", @asset_print) } }
		end
	end 

	def find_page(page)
		@pages.select{|p| p.url == page.url}.first
	end

	def find_parent_page(page)
		@pages.map{|p| p.find_child(page.parent_page.request_uri)}.compact.first if !page.parent_page.nil?
	end
end

sitemap = Sitemap.new(ARGV[0], ARGV[1])