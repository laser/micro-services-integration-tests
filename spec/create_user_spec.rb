require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Creating a user' do
  before(:all) do
    uri = URI("#{Capybara.app_host}/users/reset")
    res = Net::HTTP.post_form(uri, {})
    expect(res.code).to_not eq("500")
  end

  let(:timestamp) { Time.now.to_i.to_s }
  let(:full_name) { "Erin (#{timestamp})" }

  def create_user
    visit '/'

    click_on 'Create new user'

    fill_in 'Full name', with: full_name
    fill_in 'Email', with: "erin+#{timestamp}@carbonfive.com"
    fill_in 'Phone', with: "#{rand(9999999999)}"

    click_on 'Save User'
  end

  it 'allows new user creation' do
    create_user

    expect(page).to have_content("Successfully created user with name #{full_name}")
  end
end
