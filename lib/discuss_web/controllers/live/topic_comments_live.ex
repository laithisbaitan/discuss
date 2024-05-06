defmodule DiscussWeb.TopicCommentsLive do
  use DiscussWeb, :live_view
  alias Discuss.Repo
  alias Discuss.Topic


  # %{"id" => topic_id} = params
  def mount(%{"id" => topic_id}, _session, socket) do
    topic = Repo.get!(Topic, topic_id)

    {:ok, assign(socket, topic: topic)}
  end
end
