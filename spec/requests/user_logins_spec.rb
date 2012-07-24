require 'spec_helper'

describe "UserLogins" do
  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: 'Sign in') }
  end
  
  describe "signin" do
    before { visit login_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('h1', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
    end
     describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Name",    with: user.name
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
      
      it { should have_selector('h1',    text: 'Sign Up For BlackJack') }
      it { should_not have_selector('div.alert.alert-error') }
    end
  end
end
