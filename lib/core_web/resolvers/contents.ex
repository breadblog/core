defmodule CoreWeb.Resolvers.Contents do

  def list_posts(_parent, _args, _resolution) do
    {:ok, Core.Contents.list_posts()}
  end

end
