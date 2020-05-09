defmodule BlogCore.Factory do
  alias BlogCore.Accounts.Author
  alias BlogCore.Accounts.User
  alias BlogCore.Contents.Comment
  alias BlogCore.Contents.Post
  alias BlogCore.Contents.Tag

  def build(factory_name), do: build(factory_name, %{}, [])

  def build(factory_name, overrides) when is_map(overrides),
    do: build(factory_name, overrides, [])

  def build(factory_name, opts) when is_list(opts), do: build(factory_name, %{}, opts)

  def build(factory_name, overrides, opts) when is_map(overrides) and is_list(opts) do
    built =
      pbuild(factory_name, opts)
      |> struct(overrides)

    if Keyword.get(opts, :map, true) do
      built
      |> to_map
    else
      built
    end
  end

  defp pbuild(:comment, _opts) do
    %Comment{
      value: "a good comment #{unique()}"
    }
  end

  defp pbuild(:tag, _opts) do
    %Tag{
      description: "a good tag description #{unique()}",
      name: "tagname#{unique()}"
    }
  end

  defp pbuild(:post, opts) do
    post = %Post{
      body: "good post body #{unique()}",
      description: "a good post description #{unique()}",
      title: "a good post title #{unique()}",
      published: false
    }

    if preload?(opts) do
      post
      |> Map.put(:author, build(:author, map: false, preload: true))
      |> Map.put(:tags, [
        build(:tag, %{name: "first tag"}),
        build(:tag, %{name: "second tag"})
      ])
      |> Map.put(:comments, [
        build(:comment, %{value: "first comment"}),
        build(:comment, %{value: "second comment"})
      ])
    else
      post
    end
  end

  defp pbuild(:user, _opts) do
    %User{
      bio: "a good user bio #{unique()}",
      email: "email#{unique()}@example.com",
      name: "a good name #{unique()}",
      username: "username#{random(5)}",
      password:  "GoodPa$$word#{random(5)}"
    }
  end

  defp pbuild(:author, opts) do
    author = %Author{}

    if preload?(opts) do
      author
      |> Map.put(:user, build(:user, map: false, preload: true))
    else
      author
    end
  end

  defp to_map(x) when is_struct(x) do
    x
    |> Map.from_struct()
    |> to_map()
  end

  defp to_map(x) when is_map(x) do
    x
    |> Enum.filter(fn {key, _value} -> key not in [:schema, :inserted_at, :updated_at, :id] end)
    |> Enum.filter(fn {key, _value} ->
      [~r/^__/, ~r/_id$/]
      |> Enum.any?(&(String.match?(Atom.to_string(key), &1)))
      |> Kernel.not
    end)
    |> Enum.filter(fn {_key, value} -> not is_not_loaded(value) end)
    |> Enum.map(&to_map/1)
    |> Enum.into(%{})
  end

  defp to_map({key, value}) do
    {key, to_map(value)}
  end

  defp to_map(x) when is_list(x), do: Enum.map(x, &to_map/1)

  defp to_map(x), do: x

  defp is_not_loaded(%Ecto.Association.NotLoaded{} = _x), do: true
  defp is_not_loaded(_x), do: false

  defp preload?(opts) when is_list(opts) do
    Keyword.get(opts, :preload, true)
  end

  defp unique(), do: System.unique_integer([:positive])

  defp random(), do: Enum.random(0..9) |> to_string()

  defp random(count) do
    1..count
    |> Enum.map(fn _ -> random() end)
    |> Enum.join()
  end
end
