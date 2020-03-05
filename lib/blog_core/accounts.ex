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
    with user_changeset <- User.changeset(%User{}, attrs),
         %{valid?: true, data: user} <- user_changeset,
         cred_changeset <- Credential.changeset(%Credential{}, Map.put(attrs, :user_id, user.id)),
         %{valid?: true} <- cred_changeset
    do
      Repo.transaction(fn ->
        with user_res = Repo.insert(user_changeset),
             {:ok, user} <- user_res,
             cred_res = Repo.insert(cred_changeset),
             {:ok} <- cred_res
        do
          user
        end
      end)
    end
  end

  @doc """
  Creates an author

  ## Examples

    iex> create_author(%{
      bio: "New York Architect",
      email: "email@example.com",
      name: "Ted Moseby",
      username: "tmose",
      password: "MoSeBy BoYs",
    })

    BlogCore.Accounts.create_author(%{bio: "a", email: "a", name: "n", password: "p", username: "tmose"})

  """
  def create_author(attrs \\ %{}) do
    Repo.transaction(fn ->
      case create_user(attrs) do
        {:ok, %{id: id}} ->
          %Author{}
          |> Author.changeset(%{id: id})
          |> Repo.insert()

        {:error, error} -> Repo.rollback(error)

        unknown -> Repo.rollback(unknown)
      end
    end)
  end
end
