defmodule FaustWeb.ErrorViewTest do
  @moduledoc false

  use FaustWeb.ConnCase, async: true

  import Phoenix.View

  test "рендеринг 403.html" do
    assert render_to_string(FaustWeb.ErrorView, "403.html", []) =~
             "403 - You don't have permission to access"
  end

  test "рендеринг 404.html" do
    assert render_to_string(FaustWeb.ErrorView, "404.html", []) =~ "404 - Nothing to see here"
  end

  test "рендеринг 500.html" do
    assert render_to_string(FaustWeb.ErrorView, "500.html", []) =~ "500 - There was an error"
  end
end
