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
      comments: [
        build(:comment),
        build(:comment)
      ],
      author: build(:author)
    }
  end

  def build(:tag) do
    %{
      name: "tagname",
      description: "description of a tag"
    }
  end

  def build(:comment) do
    %{
      value: "a valid comment"
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

  def build(:author) do
    %{
      user: build(:user)
    }
  end

  def build(factory_name, overrides = %{}) do
    build(factory_name)
    |> Map.merge(overrides)
  end

  clean(attrs) do
    attrs
    |> Map.from_struct()
    |> Map.drop([:id, ])
  end
end
