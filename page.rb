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

  def print(input, print_assets)
    puts "#{input} #{depth}: #{url}"
    if print_assets && @static_assets.length > 0
      puts "#{input}-------- ASSETS:"
      @static_assets.map{|a| puts "#{input}--------        #{a}"}
    end
    children_pages.map{|p| p.print("#{input}----", print_assets)}
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
