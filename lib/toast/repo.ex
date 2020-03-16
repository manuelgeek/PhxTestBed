defmodule Toast.Repo do
  use Ecto.Repo,
    otp_app: :toast,
    adapter: Ecto.Adapters.Postgres
end
