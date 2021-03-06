# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
  before do
    @user = User.new( name:   "example user",
                            email:  "user@example.com",
                            password: "foobar",
                            password_confirmation: "foobar" )
  end
                            
  subject{@user}
  
  it{should respond_to(:email)}
  it{should respond_to(:name)}
  it{should respond_to(:password_digest)}
  it{should respond_to(:password)}
  it{should respond_to(:password_confirmation)}
  it{should respond_to(:remember_token)}
  it{should respond_to(:authenticate)}
  
  it{should be_valid}
  
  describe "when name is not present" do
    before {@user.name = " "}
    it {should_not be_valid}
  end
  
  describe "when name is too long" do
    before{@user.name= "a"*51}
    it {should_not be_valid}
  end
 
  
  #
  #
  # Email Tests
  #
  
  describe "when email address is taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it{should_not be_valid}
  end
  
  describe "when email is not present" do
    before {@user.email = " "}
    it {should_not be_valid}
  end
  
  describe "when email address is invalid" do
    invalid_email_addresses = %w[user@foo,com saldjatcom@com.com. sda@godaddycom user_at_whatevs.com]
    invalid_email_addresses.each do |invalid_email_address|
      before {@user.email = invalid_email_address}
      it {should_not be_valid}
    end
  end
  
  describe "when email adress is valid" do
    valid_email_addresses = %w[user@foo.com emailtest@test.com.cm a+b@baz.cn]
    valid_email_addresses.each do |valid_email_address|
      before {@user.email = valid_email_address}
      it {should be_valid}
    end
  end
  
  #
  #
  #PASSWORD tests
  describe "when a password is <6" do
    before {@user.password = @user.password_confirmation = "a" *5 }
    it {should_not be_valid}
  end
  
  describe "when password is not present" do
    before {@user.password = @user.password_confirmation = " "}
    it {should_not be_valid}
  end
  
  describe "when password does not match confirmation" do
    before {@user.password = "aaaaaa",
            @user.password_confirmation = "bbbbbb"}
    it {should_not be_valid}
  end
  
  describe "when password_confrimation is NIL" do
    before {@user.password_confirmation = nil}
    it { should_not be_valid }
  end
  
  #
  #
  # Authenticate tests
  describe "return value of authenticate method" do
    before {@user.save}
    ## Create a found_user variable using find_by_email
    ## and memoizies the value for the upcoming tests
    let(:found_user) {User.find_by_email(@user.email)}
    
    describe "with valid password" do
      it {should == found_user.authenticate(@user.password)}
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  
  describe "remember token " do
    before {@user.save}
    its(:remember_token){should_not be_blank}
  end
  
 end

