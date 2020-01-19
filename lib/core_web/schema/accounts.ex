defmodule CoreWeb.Schema.Accounts do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :username, :string
    field :posts, list_of(:post)
  end

  object :credentials do
    field :id, :id
    field :hash, :string
  end
end
