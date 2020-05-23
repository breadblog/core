# Global data

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

tags
|> Enum.map(&Core.Contents.create_tag!/1)
|> Enum.map(&Map.from_struct/1)

# Create current user information
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
        "id" => "49054959-c5bc-4714-8fc5-f908765805f6",
        "name" => "privacy",
        "description" => "Your ability to control who knows your private information"
      }
    ]
  },
  curr_user
)

# Create other user information

other_user =
  Core.Accounts.create_user!(%{
    "name" => "The Other Person",
    "username" => "otherperson",
    "password" => "Oth3rPerson!"
  })

Core.Contents.create_post!(
  %{
    "title" => "The Other Post",
    "description" => "Wasn't the title enough?",
    "published" => false,
    "body" => "a body",
    "tags" => [
      %{
        "id" => "e7d8d66a-3070-402a-93c7-4f65094cd986",
        "name" => "elm",
        "description" => "A functional programming language that compiles to javascript"
      },
      %{
        "id" => "610f1e04-972e-4e18-9196-f774ed49e5da",
        "name" => "javascript",
        "description" => "A multi-paradigm language often used to build web clients"
      }
    ]
  },
  other_user
)
