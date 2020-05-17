defmodule BlogCore.Factory do
  def build(:post) do
    %{
      body: "a valid post body",
      title: "a valid post title",
      description: "a valid post description",
      published: false,
      tags: [
        build(:tag, %{name: "first"}),
        build(:tag, %{name: "second"})
      ],
      author: build(:user)
    }
  end

  def build(:tag) do
    %{
      name: "tagname",
      description: "description of a tag"
    }
  end

  def build(:user) do
    %{
      email: "example@example.com",
      name: "Testy",
      bio: "a valid user bio",
      username: "helloworld",
      password: "aVa1idPa$$word"
    }
  end

  def build(factory_name, overrides = %{}) do
    build(factory_name)
    |> Map.merge(overrides)
  end
end
