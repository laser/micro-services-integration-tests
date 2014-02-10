require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Creating a user' do
  let(:timestamp) { Time.now.to_i.to_s }
  let(:full_name_a) { "Erin (#{timestamp})" }
  let(:full_name_b) { "Joe (#{timestamp})" }

  def create_user(full_name, email, phone_number)
    visit '/'
    click_on 'Create new user'

    fill_in 'Full name', with: full_name
    fill_in 'Email', with: email
    fill_in 'Phone', with: phone_number
    click_on 'Save User'

    yield page
  end

  def update_user_email(full_name, new_email)
    visit '/'
    click_on "#{full_name}"

    fill_in 'Email', with: new_email
    click_on 'Save User'

    yield page
  end

  def delete_user(full_name)
    visit '/'
    find(:xpath, "//td[contains(.//a/text(), '#{full_name}')]/..").find('.delete').click()

    yield page
  end

  before 'creating two users' do
    create_user full_name_a, "erin+#{timestamp}@carbonfive.com", "#{rand(9999999999)}" do |index_page|
      expect(index_page).to have_content("Successfully created user with name #{full_name_a}")
    end

    create_user full_name_b, "joe+#{timestamp}@carbonfive.com", "#{rand(9999999999)}" do |index_page|
      expect(index_page).to have_content("Successfully created user with name #{full_name_b}")
    end
  end

  before 'validates user input' do
    update_user_email(full_name_a, "joe+#{timestamp}@carbonfive.com") do |edit_page|
      expect(edit_page).to have_content("Error editing user")
    end
  end

  before 'allows for editing a user' do
    new_email = "erin+#{timestamp.to_i + 1}@carbonfive.com"

    update_user_email(full_name_a, new_email) do |edit_page|
      expect(edit_page).to have_content("Successfully edited user with name #{full_name_a}")
    end

    visit '/'
    expect(page).to have_content(new_email)
  end

  before 'allows for deletion of a user' do
    delete_user full_name_a do |index_page|
      expect(index_page).to have_content("Successfully deleted user with name #{full_name_a}")
    end

    delete_user full_name_b do |index_page|
      expect(index_page).to have_content("Successfully deleted user with name #{full_name_b}")
    end
  end

  it 'completes the user lifecycle' do
    visit '/'
    expect(page).to_not have_content(full_name_a)
  end

end
