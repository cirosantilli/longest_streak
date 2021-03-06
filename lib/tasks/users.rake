namespace :users do
  desc "Fetch users from GitHub"
  task populate: :environment do
    if User.count == 0
      last = 0
    else
      last = User.last.github_id
    end
    rate_limit = 5000
    connection = Connection.new
    puts connection.username
    while rate_limit > 10 do
      list = connection.user_list(last)
      list.each do |u|
        user = User.new
        my_user = GithubUser.new(u)
        user = User.new(username: my_user.login, github_id: my_user.id)
        user.save
        last = connection.last_user list
      end
    end
  end
end
