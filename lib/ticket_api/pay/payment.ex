defmodule TicketApi.Pay.Payment do
  use Ecto.Schema
  import Ecto.Changeset
  alias TicketApi.Pay.PaymentAdapter


  schema "payments" do
    field :info, :string
    field :card_info, :string, virtual: true
    field :currency, :string, virtual: true
    belongs_to :ticket, TicketApi.Tick.Ticket, foreign_key: :ticket_id
    belongs_to :user, TicketApi.Auth.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:info, :currency, :card_info])
    |> validate_required([:info])
    |> validate_has_card_info_on_create
    |> validate_inclusion(:currency, [nil, "eur", "pln", "usd"])
    |> charge_money
    |> nullify_card_info
  end

  def validate_has_card_info_on_create(changeset) do
    if changeset.valid? do
      if is_nil(get_field(changeset, :created_at)) do
        check_nil_card_info_currency(changeset)
      else
        changeset
      end
    else
      changeset
    end
  end

  def charge_money(changeset) do
    # PaymentAdapter.charge
    changeset
  end
  def nullify_card_info(changeset) do
    changeset
  end

  defp check_nil_card_info_currency(changeset)do
    if is_nil(get_field(changeset, :card_info)) do
      add_error(changeset, :card_info, "Can't be blank")
    end
    if is_nil(get_field(changeset, :currency)) do
      add_error(changeset, :card_info, "Can't be blank")
    end
    changeset
  end
end
