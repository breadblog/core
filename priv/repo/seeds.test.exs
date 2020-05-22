# Global data

tags = [
  %{name: "elixir", description: "A functional programming language that compiles to erlang"},
  %{name: "elm", description: "A functional programming language that compiles to javascript"},
  %{name: "javascript", description: "A multi-paradigm language often used to build web clients"},
  %{name: "privacy", description: "Your ability to control who knows your private information"}
]

tags
|> Enum.map(&Core.Contents.create_tag!/1)
|> Enum.map(&Map.from_struct/1)

# Create current user information
curr_user =
  Core.Accounts.create_user!(%{
    name: "Frodo Baggins",
    username: "frodo",
    password: "St1ngs?!"
  })

Core.Contents.create_post!(%{
  author_id: curr_user.id,
  title: "My Post",
  description: "My Post Description",
  published: false,
  body: "a body"
})

# Create other user information

other =
  Core.Accounts.create_user!(%{
    name: "The Other Person",
    username: "otherperson",
    password: "Oth3rPerson!"
  })

Core.Contents.create_post!(%{
  author_id: other.id,
  title: "The Other Post",
  description: "Wasn't the title enough?",
  published: false,
  body: "a body"
})
