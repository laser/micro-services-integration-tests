require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Creating a user' do
  before(:all) do
    uri = URI("#{Capybara.app_host}/users/reset")
    res = Net::HTTP.post_form(uri, {})
    expect(res.code).to_not eq("500")
  end

  let(:timestamp) { Time.now.to_i.to_s }
  let(:full_name) { "Erin (#{timestamp})" }

  before 'creating a user' do
    visit '/'
    click_on 'Create new user'

    fill_in 'Full name', with: full_name
    fill_in 'Email', with: "erin+#{timestamp}@carbonfive.com"
    fill_in 'Phone', with: "#{rand(9999999999)}"
    click_on 'Save User'
    expect(page).to have_content("Successfully created user with name #{full_name}")
  end

  before 'allows for editing a user' do
    visit '/'
    click_on "#{full_name}"

    new_email = "erin+#{timestamp}+2@carbonfive.com"
    fill_in 'Email', with: new_email
    click_on 'Save User'
    expect(page).to have_content("Successfully edited user with name #{full_name}")

    visit '/'
    expect(page).to have_content(new_email)
  end


  before 'allows for deletion of a user' do
    visit '/'
    find(:xpath, "//td[contains(.//a/text(), '#{full_name}')]").parent().find('.delete').click()
    expect(page).to have_content("Successfully deleted user with name #{full_name}")
  end

  it 'completes the user lifecycle' do
    visit '/'
    expect(page).to_not have_content(full_name)
  end

end
