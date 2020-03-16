defmodule ToastWeb.PageController do
  use ToastWeb, :controller

  def index(conn, _params) do
    conn
    |> PhxIzitoast.success("Success", "This is a Success message", position: "center")
    |> PhxIzitoast.warning("Warning", "This is a warning Message", position: "bottomRight")
    |> PhxIzitoast.error("Error", "This is an Error", position: "bottomLeft")
    |> PhxIzitoast.info("Notice", "This is a Notice", position: "topRight")
    |> PhxIzitoast.message("I am a  Message, Peace")
    |> render("index.html")
  end
end
