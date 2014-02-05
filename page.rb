require 'uri'
require 'net/https'

class Page
  attr_accessor :children_pages, :static_assets, :parent_page, :url, :title, :depth
  def initialize(url, parent, title, depth, assets)
  	@url            = url
    @title          = title
    @parent_page    = parent
  	@children_pages = []
  	@static_assets  = assets
    @depth          = depth
  end

  def print(input)
    puts "#{input}#{url}"
    children_pages.map{|p| p.print("#{input}----")}
  end

  def find_child(url)
    if @url.request_uri == url 
      return self
    elsif @children_pages.length > 0
      @children_pages.map{|p| p.find_child(url)}.compact.first
    else
      return nil
    end
  end
end
