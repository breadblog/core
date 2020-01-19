defmodule CoreWeb.Schema.Contents do
  use Absinthe.Schema.Notation

  object :post do
    field :id, :id
    field :title, :string
    field :description, :string
    field :body, :string
    field :author, :user
  end

  object :tag do
    field :id, :id
    field :name, :string
    field :description, :string
  end

  object :comment do
    field :id, :id
    field :value, :string
    field :user, :user
  end
end
