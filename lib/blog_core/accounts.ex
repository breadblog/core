defmodule BlogCore.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BlogCore.Repo
  alias BlogCore.Accounts.User
  alias BlogCore.Accounts.Author
  alias Monad.Result
  alias Monad.Maybe
  import Monad

  @doc """
  Creates a user

  ## Examples

    iex> create_user(%{
      username: "orcslayer32",
      name: "Samwise",
      email: "samwise@shire.com",
      bio: "Have you seen my frying pan?",
      password: "Mountains are steep",
    })

  """
  @spec create_user(map()) :: Result.t
  defp create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> Result.from()
  end

  @doc """
  Creates an author

  ## Examples

    iex> create_author(%{
      bio: "New York Architect",
      email: "email@example.com",
      name: "Ted Moseby",
      password: "Mo$3By BoYs",
      username: "tmose",
    })

  """
  def create_author(attrs \\ %{})
  def create_author(%{user: user} = attrs) do
    Repo.transaction(fn ->
      create_user(user)
      |> and_then(&(create_author_changeset(attrs, &1)))
      |> and_then(&Repo.insert/1)
      |> and_then(&preload_user/1)
      |> Result.map_err(&Repo.rollback/1)
    end)
    |> Result.from()
  end
  def create_author(_), do: Result.err("author requires a 'user' property")

  defp create_author_changeset(attrs, user) do
    attrs = attrs
    |> Map.drop([:user])
    |> Map.put(:id, user.id)

    %Author{}
    |> Author.changeset(attrs)
  end

  def preload_user(data) do
    data
    |> Repo.preload(:user)
  end

  @doc """
  Update a user

  ## Examples
  
    iex> update_user(user, %{name: "Ted Evaline Moseby"})

  """
  @spec update_user(BlogCore.Accounts.User.t(), map()) :: Result.t
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
    |> Result.from()
  end

  @doc """
  Get a user

  ## Examples
    
    iex> get_user("e7086dd8-e3db-4f3a-a366-483dcf80ba43")

  """
  def get_user(id) do
    Repo.get(User, id)
    |> Result.from()
  end

  @doc """
  Get an author

  ## Examples

    iex> get_author("e7086dd8-e3db-4f3a-a366-483dcf80ba43")

  """
  @spec get_author(term()) :: Maybe.t
  def get_author(id) do
    (Repo.one from a in Author,
      where: [id: ^id],
      preload: [:user]
    )
    |> Maybe.from()
  end

  @doc """
  Get all authors

  ## Examples
  
    iex> list_authors()

  """
  @spec list_authors() :: BlogCore.Accounts.Author.t()
  def list_authors() do
    (Repo.all from a in Author,
      preload: [:user]
    )
  end

  defp filter_author(author) do
    author
    |> Maybe.from()
    |> Monad.map(fn(map) ->
      Map.update(map, :user, nil, &filter_user/1)
    end)
    |> Monad.unwrap()
  end

  defp filter_user(user) do
    user
    |> Maybe.from()
    |> Monad.map(&drop_password/1)
    |> Monad.unwrap()
  end

  defp drop_password(%{password: _} = value) do
    value
    |> Map.drop([:password])
  end
end
