author =
  Core.Accounts.create_user!(%{
    name: "The Other Person",
    username: "otherperson",
    password: "Oth3rPerson!"
  })

tags = [
  %{name: "elixir", description: "A functional programming language that compiles to erlang"},
  %{name: "elm", description: "A functional programming language that compiles to javascript"},
  %{name: "javascript", description: "A multi-paradigm language often used to build web clients"},
  %{name: "privacy", description: "Your ability to control who knows your private information"}
]

tags
|> Enum.map(&Core.Contents.create_tag!/1)
|> Enum.map(&Map.from_struct/1)

Core.Contents.create_post!(%{
  author_id: author.id,
  title: "The Other Post",
  description: "Wasn't the title enough?",
  published: false,
  body: "a body"
})
