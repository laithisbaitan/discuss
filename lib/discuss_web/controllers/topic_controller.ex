defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Repo
  alias Discuss.Topic

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  plug :check_topic_owner when action in [:update, :edit, :delete]

  def home(conn, _params) do
    # IO.inspect(conn.assigns)
    topics = Repo.all(Topic)
    render conn, :home, topics: topics
  end

  def show(conn, %{"id" => topic_id})do
    topic = Repo.get!(Topic, topic_id)
    render conn, :show, topic: topic
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, :new, changeset: changeset
  end

  # %{"topic" => topic} = params
  def create(conn, %{"topic" => topic}) do
    changeset = conn.assigns.user
    |> Ecto.build_assoc(:topics)
    |> Topic.changeset(topic)


    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: ~p"/")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error in form")
        render conn, :new, changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, :edit, changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: ~p"/")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        # |> redirect(to: ~p"/topics/@topic_id/edit", changeset: changeset)
        render conn, :edit, changeset: changeset, topic: old_topic
    end
  end

  def delete(conn,  %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete!()

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: ~p"/")
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit this topic")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
