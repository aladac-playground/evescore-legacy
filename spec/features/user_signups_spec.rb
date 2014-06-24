require 'rails_helper'

feature "User Signup", :type => :feature do
  describe "new_user_registration" do
    it "allows user to sign up" do
      visit new_user_registration_path
      fill_in 'user[email]', with: "example@example.com"
      fill_in 'user[password]', with: "12345678"
      fill_in 'user[password_confirmation]', with: "12345678"
      click_button 'Sign up'
      expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please open the link to activate your account.')
    end
  end
end
