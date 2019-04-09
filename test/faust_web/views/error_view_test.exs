defmodule FaustWeb.ErrorViewTest do
  use FaustWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(FaustWeb.ErrorView, "404.html", []) =~ "404 - Nothing to see here"
  end

  test "renders 500.html" do
    assert render_to_string(FaustWeb.ErrorView, "500.html", []) =~ "500 - There was an error"
  end
end
