defmodule ToastWeb.Api.GeneralController do
  @moduledoc false
  use ToastWeb, :controller

  #   alias Toast.Services.Mpesa

  def test(conn, _) do
    case Mpesa.make_request(10, "254724540039", "reference", "description") do
      {:ok, response} ->
        conn
        |> put_status(200)
        |> json(%{data: response})

      {:error, message} ->
        conn
        |> put_status(403)
        |> json(%{data: message})
    end
  end

  def at_sms(conn, %{"phoneNumber" => phone, "text" => _text} = params) do
    IO.inspect(params)
    {:ok, response} = AtEx.USSD.build_response("My Phone is: " <> phone, :cont)
    text(conn, response)
  end
end
