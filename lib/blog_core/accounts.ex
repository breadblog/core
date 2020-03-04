defmodule BlogCore.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BlogCore.Repo
  alias BlogCore.Accounts.User
  alias BlogCore.Accounts.Credential
  alias BlogCore.Accounts.Author

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
  def create_user(attrs \\ %{}) do
    # TODO: shouldn't insert any until we have verified all of them
    # are valid for insert
    # TODO: should return the user
    res = %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    case res do
      {:ok, %{id: id}} ->
        %Credential{}
        # TODO: need to merge user_id somehow?
        |> Credential.changeset(Map.put(attrs, :user_id, id))
        |> Repo.insert()
      err ->
        err
    end
  end

  @doc """
  Creates an author

  ## Examples

    iex> create_author(%{
      bio: "New York Architect",
      email: "email@example.com",
      name: "Ted Mosby",
      username: "tmose",
    })

  """
  def create_author(attrs \\ %{}) do
    # TODO: create user
    res = %User{}
    |> User.changeset(attrs)
    |> Repo.insert()

    # TODO: create credentials

    # TODO: create author
  end
end
