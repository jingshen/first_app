require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    def fill_with_valid_information
      fill_in "Name",         with: "Example User"
      fill_in "Email",        with: "user@example.com"
      fill_in "Password",     with: "foobar"
      fill_in "Confirmation", with: "foobar"
    end
      
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }

    describe "with invalid information" do
      it "should not create a user when there is no info" do
        expect { click_button "Create my account" }.not_to change(User, :count)
      end
      
      describe "should show error when name is blank" do
        before do
          fill_with_valid_information
          fill_in "Name", with: ""          
          click_button "Create my account"
        end
        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('Name can\'t be blank') }
      end
    end

    describe "with valid information" do
      before { fill_with_valid_information } 

      it "should create a user" do
        expect do
          click_button "Create my account"
        end.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button "Create my account" }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
end
