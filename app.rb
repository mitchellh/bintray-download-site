require 'sinatra'
require_relative "lib/bintray"

required = [
  "BINTRAY_USER",
  "BINTRAY_API_KEY",
  "BINTRAY_PROJECT",
  "BINTRAY_PACKAGE",
  "DOWNLOADS_PAGE"]
required.each do |k|
  if !ENV[k]
    puts "Required setting not found: #{k}"
    exit 1
  end
end

configure do
  set :bintray_user, ENV["BINTRAY_USER"]
  set :bintray_api_key, ENV["BINTRAY_API_KEY"]
  set :bintray_project, ENV["BINTRAY_PROJECT"]
  set :bintray_package, ENV["BINTRAY_PACKAGE"]
  set :bintray, Bintray.new(settings.bintray_user, settings.bintray_api_key)
  set :downloads_page, ENV["DOWNLOADS_PAGE"]
end

get "/" do
  redirect to(settings.downloads_page), 302
end

get %r{/latest/([\w\/]+)} do |platform|
  latest_version = settings.bintray.latest_version(
    settings.bintray_project, settings.bintray_package)

  redirect to("/v/#{latest_version}/#{platform}"), 302
end

get %r{/v/([^\/]+)/([\w\/]+)} do |version, platform|
  parts = platform.split("/")
  if parts.length != 2
    halt "Bad platform: #{platform}"
  end

  os   = parts[0]
  arch = parts[1]
  url  = "https://dl.bintray.com/" +
    settings.bintray_user + "/" +
    settings.bintray_project +
    "/#{version}_#{os}_#{arch}.zip"

  redirect to(url), 302
end
