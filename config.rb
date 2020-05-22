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

teamPath = "/about/professional-team/"
memberTemplate = "/templates/member-template.html"
memberIndexTemplate = "/templates/member-index-template.html"
listingsPath = "/property-listings/"
listingsIndexTemplate = "/templates/listings.html"
countryTemplate = "/templates/country.html"
servicesTemplate = "/templates/service-template.html"
servicesPath = "/services/"

dato.members.each do |member|
  unless member.bio.nil?
    proxy "#{teamPath}#{member.name.parameterize}/index.html", memberTemplate, :locals => {:member => member}, :ignore => true
  end
end

dato.countries.each do |country|
  proxy "#{listingsPath}#{country.name.parameterize}/index.html", 
        listingsIndexTemplate, :locals => {:country => country}, :ignore => true

  proxy "#{teamPath}#{country.name.parameterize}/index.html", 
        memberIndexTemplate, :locals => {:country => country}, :ignore => true

  proxy "#{country.name.parameterize}/index.html", 
        countryTemplate, :locals => {:country => country}, :ignore => true
end

dato.listings.each do |listing|
  proxy "#{listingsPath}#{listing.property_name.parameterize}/index.html", "/templates/listing.html",
    locals: { property: listing }
end

dato.services.each do |service|
  proxy "#{servicesPath}#{service.title.parameterize}/index.html", servicesTemplate,
    locals: { service: service }
end

activate :pagination
paginate dato.listings[0...8], "/property-listings", "/templates/listings.html", suffix: "/page/:num/index", per_page: 5

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

  def listings_as_json
    dato.listings.select{ |l| l.status != "Hidden" }.map { |listing|
      ({
        property_name: listing.property_name,
        categories: listing.categories.map{ |cat| cat.title },
        country: listing.country.name,
        description: listing.description
      })
    }.to_json
  end

end
