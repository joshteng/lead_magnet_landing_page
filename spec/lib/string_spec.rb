describe String do
  context "#to_boolean" do
    specify "response to #to_boolean" do
      expect("string").to respond_to(:to_boolean)
    end

    specify "true is boolean true" do
      "true".to_boolean.should be_true
    end

    specify "false is boolean false" do
      "false".to_boolean.should be_false
    end

    specify "all else is false" do
      "anystring".to_boolean.should be_false
    end
  end
end