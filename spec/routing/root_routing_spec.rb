require "rails_helper"

RSpec.describe "routes for Widgets", :type => :routing do
  it "routes /widgets to the widgets controller" do
    expect(get("/")).  to route_to("welcome#home")
  end
end
