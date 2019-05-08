class GithubService

  def get_repos
    get_json('user/repos')
  end

  def get_followers
    get_json('user/followers')
  end

  def get_following
    get_json('user/following')
  end

  private

  def get_json(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new("https://api.github.com/") do |f|
      f.params[:access_token] = ENV["GITHUB_TOKEN_KEY"]
      f.adapter Faraday.default_adapter
    end
  end

end