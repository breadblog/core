defmodule Core.Factory do
  def build(:user), do: build(:user, :create)

  def build(:post), do: build(:post, :create)

  def build(:tag), do: build(:tag, :create)

  def build(:user, :create) do
    %{
      "name" => "some name",
      "password" => "some password A1!",
      "username" => "someusername"
    }
  end

  def build(:user, :update) do
    %{
      "name" => "some updated name",
      "password" => "some updated password A1!",
      "username" => "updatedusername"
    }
  end

  def build(:user, :invalid) do
    %{"name" => nil, "password" => "badpassword", "username" => nil}
  end

  def build(:post, :create) do
    %{
      "body" => "some body",
      "description" => "some description",
      "title" => "some title",
      "tags" => [
        %{
          "id" => "450f4254-f451-444f-83c6-89e521047312",
          "name" => "elixir",
          "description" => "A functional programming language that compiles to erlang"
        },
        %{
          "id" => "e7d8d66a-3070-402a-93c7-4f65094cd986",
          "name" => "elm",
          "description" => "A functional programming language that compiles to javascript"
        }
      ],
      "published" => true
    }
  end

  def build(:post, :update) do
    %{
      "body" => "some updated body",
      "description" => "some updated description",
      "title" => "some updated title",
      "tags" => [
        %{
          "id" => "e7d8d66a-3070-402a-93c7-4f65094cd986",
          "name" => "javascript",
          "description" => "A multi-paradigm language often used to build web clients"
        },
        %{
          "id" => "49054959-c5bc-4714-8fc5-f908765805f6",
          "name" => "privacy",
          "description" => "Your ability to control who knows your private information"
        }
      ],
      "published" => false
    }
  end

  def build(:post, :invalid) do
    %{"body" => nil, "description" => nil, "title" => nil, "published" => nil}
  end

  def build(:tag, :create) do
    %{"description" => "some description", "name" => "tagname"}
  end

  def build(:tag, :update) do
    %{"description" => "some updated description", "name" => "updatename"}
  end

  def build(:tag, :invalid) do
    %{"description" => nil, "name" => nil}
  end
end
