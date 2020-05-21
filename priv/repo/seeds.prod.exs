# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Core.Repo.insert!(%Core.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

tags = [
  %{name: "elixir", description: "A functional programming language that compiles to erlang"},
  %{name: "elm", description: "A functional programming language that compiles to javascript"},
  %{name: "javascript", description: "A multi-paradigm language often used to build web clients"},
  %{name: "privacy", description: "Your ability to control who knows your private information"},
]

Enum.each(tags, &Core.Contents.create_tag!/1)
