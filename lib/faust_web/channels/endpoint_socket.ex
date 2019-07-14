defmodule FaustWeb.EndpointSocket do
  use Phoenix.Socket

  alias Faust.Accounts
  alias Faust.Crypto

  ## Channels
  channel "current_user:*", FaustWeb.CurrentUserChannel
  channel "snoop:follower:*", FaustWeb.SnoopFollowerChannel
  channel "search:content:*", FaustWeb.SearchContentChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, Crypto.secret_key_base(), token, max_age: :infinity) do
      {:ok, "user_id:" <> user_id} ->
        current_user = Accounts.get_user!(user_id)

        {:ok, assign(socket, :current_user, current_user)}

      {:error, _reason} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     FaustWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(%{assigns: %{current_user: current_user}}) do
    "endpoint_socket:#{current_user.id}"
  end
end