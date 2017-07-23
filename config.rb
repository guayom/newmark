page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

configure :development do
  activate :livereload
end

activate :directory_indexes

activate :dato,
  domain: 'https://newmark.admin.datocms.com',
  token: '93430d102176ac91ec983a7ca1aa7eb7d7769b06570c9a408c',
  base_url: 'https://newmark.netlify.com/'


set :site_url, "https://ngcentralamerica.com"
set :markdown_engine, :redcarpet

ignore "/templates/*"

activate :navtree do |options|
  options.data_file = 'tree.yml' # The data file where our navtree is stored.
  options.automatic_tree_updates = true # The tree.yml file will be updated automatically when source files are changed.
  options.ignore_files = ['sitemap.xml', 'robots.txt'] # An array of files we want to ignore when building our tree.
  options.ignore_dir = ['assets'] # An array of directories we want to ignore when building our tree.
  options.home_title = 'Home' # The default link title of the home page (located at "/"), if otherwise not detected.
  options.promote_files = ['index.html.erb'] # Any files we might want to promote to the front of our navigation
  options.ext_whitelist = ['.md', '.markdown'] # If you add extensions (like '.md') to this array, it builds a whitelist of filetypes for inclusion in the navtree.
end

dato.articles.each do |article|
  proxy "/media-center/press-releases/#{article.title.parameterize}/index.html", "/media-center/press-releases/template.html", :locals => { :article => article }, :ignore => true
end

dato.members.each do |member|
  unless member.bio.nil?
    proxy "/about/professional-team/#{member.name.parameterize}/index.html", "/templates/member-template.html", :locals => {:member => member}, :ignore => true
  end
end

dato.listings.each do |listing|
  proxy "/property-listings/#{listing.property_name.parameterize}.html", "/templates/listing.html",
    locals: { property: listing }
end

activate :pagination
paginate dato.listings, "/property-listings", "/templates/listings.html", suffix: "/page/:num/index", per_page: 5

configure :build do
end

###
# Helpers
###

require 'nokogiri'

# Methods defined in the helpers block are available in templates
helpers do
  def nav_active(path)
    current_page.path == path ? {:class => "active"} : {}
  end

  # Returns all pages under a certain directory.
  def sub_pages(dir)
    sitemap.resources.select do |resource|
      unless resource.path.split('.').last == 'pdf' || resource.path.split('.').last == 'jpg' || resource.path.split('.').last == 'png' || resource.data.category == 'team'
        resource.path.start_with?(dir)
      end
    end.sort_by { |resource| resource.data.weight }
  end

  def get_download_link(file)
    "https://www.datocms-assets.com#{file.file.path}?dl=#{file.title.parameterize}.pdf"
  end

  def extract_first_paragraph(string)
    Nokogiri::HTML.parse(string).css('p').first.text
  end

end
