<p align="center"><img src="https://magak.me/assets/images/Geek-logo.png" width="150"></p>

# Phoenix TestBed
This is a Application to show how to use various Phoenix packages from My Packages and the Elixir Kenya community

## Configutation
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Included packages
1. PhxIzitoast
2. AtEx - Africastalking
    - SMS 
    - USSD
3. Mpesa Elixir


# Packages 
## 1. [PhxIzitoast](https://github.com/manuelgeek/phx_izitoast)
This is a Phoenix Elixir IziToast Notification wrapper. https://izitoast.marcelodolza.com, A JavaScript Notifications Toast Library.

[Package documentation](https://hex.pm/packages/phx_izitoast)

### Usage
Navigate to [localhost](http://localhost:4000) to view the toasts
Code sample found at `/controllers/page_controller.ex` 
``` elixir 
  def index(conn, _params) do
    conn
    |> PhxIzitoast.success("Success", "This is a Success message", position: "center")
    |> PhxIzitoast.warning("Warning", "This is a warning Message", position: "bottomRight")
    |> PhxIzitoast.error("Error", "This is an Error", position: "bottomLeft")
    |> PhxIzitoast.info("Notice", "This is a Notice", position: "topRight")
    |> PhxIzitoast.message("I am a  Message, Peace")
    |> render("index.html")
  end
  ```
----------

## 2. [AtEx - dev](https://github.com/beamkenya/africastalking-elixir)
An API Wrapper for the Africas Talking API 
The wrapper is still under dev, 

[Contribute](https://github.com/beamkenya/africastalking-elixir)

### SMS 
#### Sending SMS 

``` elixir
iex> AtEx.send_sms(%{to: "+254724540039",     message: "Yes Bana"})
{:ok,
        %{
          "SMSMessageData" => %{
          "Message" => "Sent to 1/1 Total Cost: ZAR 0.1124",
          "Recipients" => [
          %{
           "cost" => "KES 0.8000",
           "messageId" => "ATXid_96e52a761a82c1bad58e885109224aad",
           "number" => "+254724540039",
           "status" => "Success",
           "statusCode" => 101
          }
          ]
        }
      }}

```
----------

### USSD 
To generate the response, you can use the function `AtEx.USSD.build_response/1` or `AtEx.USSD.build_response/2`.
``` elixir 
 iex> AtEx.USSD.build_response("What do you want to order", ["Chips & Sausage", "Burger & Chips", "Rice & beans"])
{:ok, "CON What do you want to order\n1. Chips & Sausage\n2. Burger & Chips\n3. Rice & beans" }
```
Look at `/controllers/api/ussd_controller.ex` for a sample USSD app
[link](https://github.com/manuelgeek/PhxTestBed/blob/master/lib/toast_web/controllers/api/ussd_controller.ex)

----------

## 3. [Mpesa Elixir](https://github.com/manuelgeek/mpesa_elixir)
This is wrapper for Daraja Mpesa STK implementation(Lipa na Mpesa Online)

[Online Documentation](https://www.hex.pm/packages/mpesa)

### Usage

``` elixir 
    iex> Mpesa.make_request(10, "254724540039", "reference", "description")
      {:ok,
        %{
        "CheckoutRequestID" => "ws_CO_010320202011179845",
        "CustomerMessage" => "Success. Request accepted for processing",
        "MerchantRequestID" => "25558-10595705-4",
        "ResponseCode" => "0",
        "ResponseDescription" => "Success. Request accepted for processing"
        }}

        {:error, "Invalid Access Token"}
```

----------

## About Me

[Magak Emmanuel](https://magak.me)

----------

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

[![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=for-the-badge)](#)

[![Open Source Love](https://badges.frapsoft.com/os/v2/open-source-200x33.png?v=103)](#)


Happy coding, Star before Fork 😊💪💯

----------


## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
