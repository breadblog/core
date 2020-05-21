tags = [
  %{name: "elixir", description: "A functional programming language that compiles to erlang"},
  %{name: "elm", description: "A functional programming language that compiles to javascript"},
  %{name: "javascript", description: "A multi-paradigm language often used to build web clients"},
  %{name: "privacy", description: "Your ability to control who knows your private information"},
]

Enum.each(tags, &Core.Contents.create_tag!/1)
