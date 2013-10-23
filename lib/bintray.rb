require 'json'
require 'restclient'

class Bintray
  API_ROOT = "bintray.com/api/v1"

  def initialize(user, api_key)
    @user    = user
    @api_key = api_key
  end

  def latest_version(project, package)
    response = RestClient.get(
      api_url("packages/#{@user}/#{project}/#{package}/versions/_latest"))
    data = JSON.parse(response.to_s)
    data["name"]
  end

  protected

  def api_url(path)
    "https://#{@user}:#{@api_key}@#{API_ROOT}/#{path}"
  end
end
