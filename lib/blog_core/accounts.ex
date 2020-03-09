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
  alias BlogCore.Token
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
    |> Repo.insert
    |> Result.from
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
      |> map(&(create_author_changeset(attrs, &1)))
      |> and_then(&Repo.insert/1)
      |> map(&preload_user/1)
      |> Result.map_err(&Repo.rollback/1)
    end)
    |> Result.from
  end
  def create_author(_), do: Result.err("author requires a 'user' property")

  def create_test(username), do: create_author(%{user: %{username: username, password_hash: "The Gr34te$t", name: "Test", email: "email@example.com"}})

  @doc """
  Get a single user by their username
  """
  @spec get_user_from_username(String.t()) :: Maybe.t()
  def get_user_from_username(username) do
    (Repo.one from User,
      where: [username: ^username]
    )
    |> Maybe.from()
  end

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

  @doc """
  Check credentials and return a token
  """
  @spec login(String.t(), String.t()) :: Result.t()
  def login(username, password) do
    username
    |> get_user_from_username()
    |> Result.from_maybe("no user with username")
    |> Monad.and_then(&check_pass(&1, password))
    |> Monad.and_then(&generate_token/1)
  end

  @spec check_pass(User.t(), String.t()) :: Result.t()
  defp check_pass(user, password) do
    case Argon2.check_pass(user, password) do
      {:ok, user} -> Result.ok(user)
      _ -> Result.err("username or password is incorrect")
    end
  end

  @spec generate_token(User.t()) :: Result.t()
  defp generate_token(user) do
    Token.generate_and_sign(%{"user_id" => user.id})
    |> to_token_result
    |> Result.map_err(fn -> "failed to generate token" end)
  end

  defp to_token_result({:ok, token, _}), do: Result.ok(token)
  defp to_token_result({:error, err}), do: Result.err(err)
end
