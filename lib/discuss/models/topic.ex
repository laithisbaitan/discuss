defmodule Discuss.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.User
    has_many :comments, Discuss.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> required_error_messages("oh no it's empty")
  end

  defp required_error_messages(changeset, new_error_message) do
    update_in changeset.errors, &Enum.map(&1, fn
      {key, {"can't be blank", rules}} -> {key, {new_error_message, rules}}
      tuple  -> tuple
    end)
  end
end
