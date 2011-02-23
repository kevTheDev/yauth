require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe User do
  subject { User.new }

  [:username, :password, :plain_password].each do |attr|
    it "should have an #{attr} accessor" do
      should respond_to(attr)
      should respond_to(attr.to_s + "=")
    end
  end

  it "should set the real password based on the plain password" do
    password = "hello world"
    hash = Digest::SHA256.hexdigest(password)
    subject.plain_password = password
    subject.password.should == hash
  end

  it "should memorize the plain password until the end of the session" do
    password = "hello world"
    subject.plain_password = password
    subject.plain_password.should == password
  end

  it "should be transformed to an hash" do
    subject.username = "XYZ"
    subject.password = "ABC"
    subject.to_hash.should == { "user" => { "username" => "XYZ", "password" => "ABC" } }
  end

  it "should yaml nicely" do
    subject.username = "XYZ"
    subject.password = "ABC"
    subject.to_yaml.should ==<<-EOF
--- 
user: 
  username: XYZ
  password: ABC
EOF
  end

  describe "as a class" do

    it "should build a user from a prefixed hash with strings" do
      u = User.new({ "user" => { "username" => "XYZ", "password" => "ABC" } })
      u.username.should == "XYZ"
      u.password.should == "ABC"
    end

    it "should build a user from an prefixed hash with symbols" do
      u = User.new({ :"user" => { :"username" => "XYZ", :"password" => "ABC" } })
      u.username.should == "XYZ"
      u.password.should == "ABC"
    end

    it "should build a user from a hash with strings" do
      u = User.new({ "username" => "XYZ", "password" => "ABC" })
      u.username.should == "XYZ"
      u.password.should == "ABC"
    end

    it "should build a user from an hash with symbols" do
      u = User.new({ :"username" => "XYZ", :"password" => "ABC" })
      u.username.should == "XYZ"
      u.password.should == "ABC"
    end
  end
end