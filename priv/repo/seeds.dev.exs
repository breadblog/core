tags = [
  %{
    "name" => "elixir",
    "description" => "A functional programming language that compiles to erlang"
  },
  %{
    "name" => "elm",
    "description" => "A functional programming language that compiles to javascript"
  },
  %{
    "name" => "javascript",
    "description" => "A multi-paradigm language often used to build web clients"
  },
  %{
    "name" => "privacy",
    "description" => "Your ability to control who knows your private information"
  }
]

tags_ids = tags
|> Enum.map(&Core.Contents.create_tag!/1)
|> Enum.map(&Map.get(&1, :id))

curr_user =
  Core.Accounts.create_user!(%{
    "name" => "Frodo Baggins",
    "username" => "frodo",
    "password" => "St1ngs?!"
  })

Core.Contents.create_post!(
  %{
    "title" => "My Post",
    "description" => "My Post Description",
    "published" => false,
    "body" => "a body",
    "tags" => [
      %{
        "id" => Enum.at(tags_ids, 0),
      }
    ]
  },
  curr_user
)
