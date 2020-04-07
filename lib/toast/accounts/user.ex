defmodule Toast.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :phone, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :phone, :password])
    |> validate_required([:name, :phone, :password])
    |> unique_phone_no
    |> validate_password(:password)
    |> validate_confirmation(:password)
    |> put_pass_hash
  end

  defp unique_phone_no(changeset) do
    changeset
    |> validate_format(
      :phone,
      ~r/^(?:254|\+254|0)?((?:[71])[0-9][0-9][0-9]{6})$/
    )
    |> unique_constraint(:phone)
  end

  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case strong_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp strong_password?(password) when byte_size(password) == 4 do
    {:ok, password}
  end

  defp strong_password?(password) when is_number(password) === false do
    {:error, "The PIN should be 4 digits"}
  end

  defp strong_password?(_), do: {:error, "The PIN should be 4 digits"}
end
