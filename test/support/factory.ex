defmodule BlogCore.Factory do
  alias BlogCore.Accounts.Author
  alias BlogCore.Accounts.User
  alias BlogCore.Contents.Comment
  alias BlogCore.Contents.Post
  alias BlogCore.Contents.Tag

  def build(:tag) do
    %Tag{
      description: "a good tag description #{unique()}",
      name: "tagname#{unique()}"
    } |> Map.from_struct()
  end

  def build(:comment) do
    %Comment{
      value: "a good comment #{unique()}"
    } |> Map.from_struct()
  end

  def build(:post) do
    %Post{
      body: "good post body #{unique()}",
      description: "a good post description #{unique()}",
      title: "a good post title #{unique()}",
      published: false,
      tags: [
        build(:tag, %{name: "first"}),
        build(:tag, %{name: "second"})
      ],
      comments: [
        build(:comment, %{value: "first comment"}),
        build(:comment, %{value: "second comment"})
      ],
      author: build(:author)
    } |> Map.from_struct()
  end

  def build(:user) do
    %User{
      bio: "a good user bio #{unique()}",
      email: "email#{unique()}@example.com",
      name: "a good name #{unique()}",
      username: "username#{random(5)}",
    }
    |> Map.from_struct()
    |> Map.put(:password, "aGoodPa$$word#{random(3)}")
  end

  def build(:author) do
    %Author{
      user: build(:user)
    } |> Map.from_struct()
  end

  def build(factory_name, %{} = overrides \\ %{}) do
    factory_name
    |> build()
    |> Map.merge(overrides)
  end

  defp unique(), do: System.unique_integer([:positive])

  defp random(), do: Enum.random(0..9) |> to_string()

  defp random(count) do
    1..count
    |> Enum.map(fn _ -> random() end)
    |> Enum.join()
  end
end
