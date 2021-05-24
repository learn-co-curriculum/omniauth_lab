require 'rails_helper'

RSpec.describe "welcome/home", type: :view, developer_strategy: true  do
  it 'offers signup with developer' do
    render
    expect(rendered).to include('<a rel="nofollow" data-method="post" href="/auth/developer">Signing in with the developer strategy</a>')
  end

  it 'offers signup with GitHub' do
    render
    expect(rendered).to include('<a rel="nofollow" data-method="post" href="/auth/github">Signing in with the GitHub strategy</a>')
  end
end

