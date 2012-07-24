require 'spec_helper'

describe "SignUp" do
  
  subject { page }
  
  describe "signup page" do
    before { visit signup_path }
    it { should have_selector('h1',    text: 'Sign Up For BlackJack') }
  end
end
describe "signup" do

  before { visit signup_path }

  let(:submit) { "Create my account" }

  describe "with invalid information" do
    it "should not create a user" do
      expect { click_button submit }.not_to change(User, :count)
    end
  end

  describe "with valid information" do
    before do
      fill_in "Name",         with: "Tim Jensen"
      fill_in "Password",     with: "abc123"
      fill_in "Confirmation", with: "abc123"
    end

    it "should create a user" do
      expect { click_button submit }.to change(User, :count).by(1)
    end
  end
end

