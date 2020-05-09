defmodule BlogCore.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BlogCore.Repo
  alias BlogCore.Accounts.User
  alias BlogCore.Accounts.Author
  alias BlogCore.Token

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
  @spec create_user(map()) :: Result.t()
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates an author

  ## Examples

    iex> create_author(%{
      user: %{
        bio: "New York Architect",
        email: "email@example.com",
        name: "Ted Moseby",
        password: "Mo$3By BoYs",
        username: "tmose",
      },
    })

  """
  @spec create_author(map()) :: {:ok, Author.t()} | {:error, any()}
  def create_author(attrs \\ %{}) do
    Repo.transaction(fn ->
      result =
        %Author{}
        |> Author.changeset(attrs)
        |> Repo.insert()

      case result do
        {:ok, output} -> output
        {:error, err} -> Repo.rollback(err)
      end
    end)
  end

  @doc """
  Get a single user by their username
  """
  @spec get_user_from_username(String.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user_from_username(username) do
    result =
      Repo.one(
        from User,
          where: [username: ^username]
      )

    case result do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @doc """
  Get a single author by their username
  """
  @spec get_author_from_username(String.t()) :: {:ok, Author.t()} | {:error, :not_found}
  def get_author_from_username(username) do
    with {:ok, user} <- get_user_from_username(username),
         user <- Repo.preload(user, :author),
         do: {:ok, user.author}
  end

  @doc """
  Update a user

  ## Examples

    iex> update_user(user, %{name: "Ted Evaline Moseby"})

  """
  @spec update_user(User.t(), map()) :: {:ok, User.t()} | {:error, any()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Get a user

  ## Examples

    iex> get_user("e7086dd8-e3db-4f3a-a366-483dcf80ba43")

  """
  @spec get_user(String.t()) :: {:ok, User.t()} | {:error, :not_found}
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  @doc """
  Get an author

  ## Examples

    iex> get_author("e7086dd8-e3db-4f3a-a366-483dcf80ba43")

  """
  @spec get_author(String.t()) :: {:ok, Author.t()} | {:error, :not_found}
  def get_author(id) do
    result =
      Repo.one(
        from a in Author,
          where: [id: ^id],
          preload: [:user]
      )

    case result do
      nil -> {:error, :not_found}
      author -> {:ok, author}
    end
  end

  @doc """
  Get all authors

  ## Examples

    iex> list_authors()

  """
  @spec list_authors() :: list(Author.t())
  def list_authors() do
    Repo.all(
      from a in Author,
        preload: [:user]
    )
  end

  @doc """
  Check credentials and return a token
  """
  @spec login(String.t(), String.t()) :: {:ok, String.t()} | {:error, any()}
  def login(username, password) do
    with {:ok, %User{} = user} <- get_user_from_username(username),
         :ok <- check_pass(user, password) do
      generate_token(user)
    end
  end

  @spec check_pass(User.t(), String.t()) :: :ok | {:error, String.t()}
  defp check_pass(user, password) do
    case Argon2.check_pass(user, password) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, "username or password is incorrect"}
    end
  end

  @spec generate_token(User.t()) :: {:ok, String.t()} | {:error, any()}
  defp generate_token(user) do
    case Token.generate_and_sign(%{"user_id" => user.id}) do
      {:ok, token, _} -> {:ok, token}
      {:error, _} = result -> result
    end
  end

  def display(%User{} = user, nil) do
    %{
      "id" => user.id,
      "bio" => user.bio,
      "name" => user.name,
      "username" => user.username
    }
  end

  def display(%User{} = user, %User{} = curr_user) do
    if user.id == curr_user.id do
      %{
        "id" => user.id,
        "bio" => user.bio,
        "email" => user.email,
        "name" => user.name,
        "username" => user.username
      }
    else
      display(user, nil)
    end
  end

  def display(%Author{} = author, %User{} = curr_user) do
    author = Repo.preload(author, :user)

    %{
      "id" => author.id,
      "user" => display(author.user, curr_user)
    }
  end
end
