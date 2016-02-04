require "spec_helper"

describe "welcome/home.html.erb" do
  it "displays all the widgets" do
    render
    auth_url = "/auth/facebook"
    rendered.should have_tag("a[href$=#{auth_url}]")
  end
end