defmodule Toast.Services.ToastPipe do
  @moduledoc false

  @doc false
  def init(opts), do: opts
  @doc false
  def call(conn, _opts) do
    conn
    |> Plug.Conn.fetch_session()
    |> Plug.Conn.delete_session(:izitoast)
  end
end
