defmodule ToastWeb.PageController do
  use ToastWeb, :controller
#   alias PhxIzitoast.Services.PhxIzitoast

  def index(conn, _params) do
    
    conn
    |> PhxIzitoast.success("Success", "This is a Success message", [position: "center", timeout: 10000])
    |> PhxIzitoast.warning("Warning", "This is a warning Message", position: "bottomRight")
    |> PhxIzitoast.error("Error", "This is an Error", position: "bottomLeft")
    |> PhxIzitoast.info("Notice", "This is a Notice", position: "topRight")
    |> PhxIzitoast.message("I am a  Message, Peace")
    # |> PhxIzitoast.clear_PhxIzitoast
    # |>IO.inspect
    # |> render("index.html")
    |> redirect(to: Routes.page_path(conn, :ind))
  end

  def ind(conn, _) do

    conn
    |> render("index.html")
  end
end
