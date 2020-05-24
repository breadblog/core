defmodule Core.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Core.Repo

  alias Core.Accounts.User

  @doc """
  Check credentials and return a token if valid
  """
  def login(username, password) do
    with user = %User{} <-
           Repo.one(
             from User,
               where: [username: ^username]
           ) || {:error, :unauthorized},
         :ok <-
           check_pass(user, password),
         {:ok, token} <- generate_token(user) do
      {:ok, token, user}
    else
      err -> err
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def get_user(%{"username" => username}) do
    case Repo.one(
           from User,
             where: [username: ^username]
         ) do
      %User{} = user -> {:ok, user}
      _ -> {:error, :not_found}
    end
  end

  def get_user(%{"id" => id}) do
    case Repo.get(User, id) do
      %User{} = user -> {:ok, user}
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user(123)
      {:ok, %User{}}

      iex> get_user(456)
      {:error, :not_found}

  """
  def get_user(id) do
    get_user(%{"id" => id})
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user!(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  defp generate_token(user) do
    case Core.Token.generate_and_sign(%{"user_id" => user.id}) do
      {:ok, token, _} -> {:ok, token}
      # this should never fail, should be logged if it does
      err -> raise err
    end
  end

  defp check_pass(user, password) do
    case Argon2.check_pass(user, password, hash_key: :password) do
      {:ok, _} -> :ok
      {:error, _} -> {:error, :unauthorized}
    end
  end
end
