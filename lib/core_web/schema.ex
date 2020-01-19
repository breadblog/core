defmodule CoreWeb.Schema do
  use Absinthe.Schema

  import_types CoreWeb.Schema.Contents
  import_types CoreWeb.Schema.Accounts

  alias CoreWeb.Resolvers

  query do

    @desc "Get all posts"
    field :posts, list_of(:post) do
      resolve &Resolvers.Contents.list_posts/3
    end

    @desc "Get a user of the blog"
    field :user, :user do
      arg :id, non_null(:id)
      resolve &Resolvers.Accounts.find_user/3
    end

  end

end
