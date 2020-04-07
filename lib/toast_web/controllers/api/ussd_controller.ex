defmodule ToastWeb.Api.UssdController do
  @moduledoc false
  use ToastWeb, :controller
  alias Toast.Accounts

  @invalid_message "Invalid Option"

  def at_sms(conn, %{"phoneNumber" => phone, "text" => text} = _params) do
    # IO.inspect(params)
    [level: level, data: data, last: last] = process_request(text)
    IO.inspect(level)
    IO.inspect(last)
    IO.inspect(data)

    # check user pass
    if(level >= 1 && String.match?(last, ~r/[0-9]{4}/)) do
      case get_user(phone) do
        nil ->
          nil

        user ->
          case Bcrypt.check_pass(user, last) do
            {:ok, user} ->
              user

            {:error, msg} ->
              text(conn, "END " <> msg)
          end
      end
    end

    case level do
      0 ->
        response =
          try do
            get_user!(phone)

            {:ok, response} =
              AtEx.USSD.build_response(app_title() <> " \nEnter PIN to continue", :cont)

            response
          rescue
            Ecto.NoResultsError ->
              {:ok, response} =
                AtEx.USSD.build_response(app_title(), ["Create a new account", "Exit"])

              response
          end

        text(conn, response)

      1 ->
        case get_user(phone) do
          nil ->
            try do
              case String.to_integer(last) do
                1 ->
                  {:ok, response} =
                    AtEx.USSD.build_response(app_title() <> "\nEnter Full Names", :cont)

                  text(conn, response)

                2 ->
                  text(conn, "END " <> app_exit())

                _ ->
                  text(conn, "END " <> @invalid_message)
              end
            rescue
              ArgumentError -> text(conn, "END " <> @invalid_message)
            end

          user ->
            cond do
              String.match?(last, ~r/[0-9]{4}/) ->
                {:ok, response} =
                  AtEx.USSD.build_response(app_title() <> " \n" <> "Hi " <> user.name, [
                    "Account",
                    "Edit Account",
                    "Test STK Push",
                    "Delete Account"
                  ])

                text(conn, response)

              true ->
                text(conn, "END " <> @invalid_message)
            end
        end

      2 ->
        case get_user(phone) do
          nil ->
            {:ok, response} =
              AtEx.USSD.build_response(app_title() <> "\nCreate secret PIN", :cont)

            text(conn, response)

          user ->
            try do
              case String.to_integer(last) do
                1 ->
                  {:ok, response} =
                    AtEx.USSD.build_response(
                      app_title() <>
                        "\nUser Details \nName: " <>
                        user.name <> " \nPhone No: " <> "0" <> String.slice(user.phone, -9, 9),
                      :end
                    )

                  text(conn, response)

                2 ->
                  text(conn, "END Pending")

                3 ->
                  case Mpesa.make_request(
                         10,
                         "254" <> String.slice(phone, -9, 9),
                         "My App Test",
                         "rand_description"
                       ) do
                    {:ok, _resp} ->
                      {:ok, response} =
                        AtEx.USSD.build_response(
                          app_title() <> "\nSTK Push Initiated, Its a test, don't pay",
                          :end
                        )

                      text(conn, response)

                    {:error, message} ->
                      {:ok, response} =
                        AtEx.USSD.build_response(app_title() <> " \n" <> message, :end)

                      text(conn, response)
                  end

                4 ->
                  {:ok, response} =
                    AtEx.USSD.build_response(
                      app_title() <> "\n" <> "Hi " <> user.name <> "Delete Account ?",
                      [
                        "Confirm",
                        "Exit"
                      ]
                    )

                  text(conn, response)

                _ ->
                  text(conn, "END " <> @invalid_message)
              end
            rescue
              ArgumentError -> text(conn, "END " <> @invalid_message)
            end
        end

      3 ->
        case get_user(phone) do
          nil ->
            {:ok, response} =
              AtEx.USSD.build_response(app_title() <> "\nRepeat secret PIN", :cont)

            text(conn, response)

          user ->
            try do
              case String.to_integer(last) do
                1 ->
                  case Accounts.delete_user(user) do
                    {:ok, _} ->
                      {:ok, response} =
                        AtEx.USSD.build_response(
                          app_title() <> "\nAccount Deleted, sad to see you go",
                          :end
                        )

                      text(conn, response)

                    {:error, _} ->
                      text(conn, "END Error Occurred, try again")
                  end

                2 ->
                  text(conn, "END " <> app_exit())

                _ ->
                  text(conn, "END " <> @invalid_message)
              end
            rescue
              ArgumentError -> text(conn, "END " <> @invalid_message)
            end
        end

      4 ->
        case get_user(phone) do
          nil ->
            %{2 => name, 3 => password, 4 => password_confirmation} = data

            case Accounts.create_user(%{
                   name: name,
                   phone: phone,
                   password: password,
                   password_confirmation: password_confirmation
                 }) do
              {:ok, user} ->
                AtEx.send_sms(%{to: phone, message: welcome_message()})

                {:ok, response} =
                  AtEx.USSD.build_response(
                    app_title() <> "\nAccount Successfully Created \nWelcome " <> user.name,
                    :end
                  )

                text(conn, response)

              {:error, %Ecto.Changeset{} = changeset} ->
                errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
                IO.inspect(errors)

                errors =
                  Map.keys(errors)
                  |> Enum.map(fn key -> "#{key}:#{errors[key]}" end)
                  |> Enum.join("\n")

                {:ok, response} =
                  AtEx.USSD.build_response(app_title() <> "\nError Occured \n" <> errors, :end)

                text(conn, response)
            end

          _user ->
            nil
        end

      _ ->
        text(conn, "END " <> @invalid_message)
    end
  end

  @spec process_request(String.t()) :: list()
  defp process_request(text) do
    case text !== "" do
      true ->
        if String.contains?(text, "*") do
          list = String.split(text, "*", trim: true)

          [
            level: length(list),
            data: 1..length(list) |> Stream.zip(list) |> Enum.into(%{}),
            last: List.last(list)
          ]
        else
          [level: 1, data: %{1 => text}, last: text]
        end

      false ->
        [level: 0, data: %{}, last: '']
    end
  end

  defp app_title, do: "Welcome to My App"

  defp app_exit, do: "Thanks for using My App"
  defp welcome_message, do: "Welcome to My App, Thanks for using My App"

  defp get_user(phone) do
    Accounts.get_by(%{"phone" => phone})
  end

  defp get_user!(phone) do
    Accounts.get_by!(%{"phone" => phone})
  end
end
