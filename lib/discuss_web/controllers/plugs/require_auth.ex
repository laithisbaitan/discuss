defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  use DiscussWeb, :controller

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end
end
