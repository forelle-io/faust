defmodule Faust.CryptoTest do
  @moduledoc false

  use Faust.DataCase

  alias Faust.Crypto

  test "generate_unique_string" do
    assert Crypto.generate_unique_string(8) |> String.length() == 8
  end

  test "generate_unique_alphabet_string" do
    unique_alphabet_string = Crypto.generate_unique_alphabet_string(8)

    assert unique_alphabet_string =~ ~r/\A[a-z]{8}\z/
  end

  test "secret_key_base" do
    secret_key_base = "Fh5SDTGCKfsqgTN4r3bX4RwSfDQzy3WsOOVQAxL+R28fAC8+oZ8jRlCAqFDmkh7+"
    Application.put_env(:faust, FaustWeb.Endpoint, secret_key_base: secret_key_base)

    assert secret_key_base == Crypto.secret_key_base()
  end
end
