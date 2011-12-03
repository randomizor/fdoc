path = File.expand_path(File.dirname(__FILE__))
require "#{path}/../spec_helper"

describe Fdoc::ResourceScaffold do
  subject { described_class }
  let(:controller_name) { "Api::MessageController" }
  let(:resource_name) { "message" }

  describe "::scaffold_resource" do
    it "should try to guess a resource name based on the controller name" do
      resource = subject.scaffold_resource(controller_name)
      resource.name.should == resource_name
    end
  end
  
  describe "#write_to_directory" do
    it "should write to a YAML file in a given directory" do
      pending "figuring out a good way to test this"
      before { subject.write_to_directory(path_prefix) }
    end
  end
end

describe Fdoc::MethodScaffold do
  describe "#scaffold_request" do
    subject { described_class.new(method_name) }
    let(:method_name) { "send" }
    let(:request_parameters) { { "id" => 12345,
                                 "email" => "smelly@pants.com",
                                 "text" => "hello pants world" } }
        
    context "with request parameters" do
      before { subject.scaffold_request(request_parameters) }
      
      it "creates a scaffolded method" do
        subject.scaffolded_method.name.should == "send"
      end
      
      it "creates placeholder parameters for each parameter it receives" do
        subject.scaffolded_method.should have(request_parameters.count).request_parameters
      end

      it "merges known parameters with new ones" do
        subject
        subject.scaffolded_method.should have(3).request_parameters

        new_request_parameters = { "id" => 54321, "email" => "captain@pants.com", "phone" => "5551234567" }
        subject.scaffold_request(new_request_parameters)
        subject.scaffolded_method.should have(4).request_parameters
        subject.scaffolded_method.request_parameter_named("id").example.should == 12345
      end

      it "should attempt to infer the types of the parameters" do
        subject.scaffolded_method.request_parameter_named("id").type.should == "Integer"
        subject.scaffolded_method.request_parameter_named("email").type.should == "String"
        subject.scaffolded_method.request_parameter_named("text").type.should == "String"
      end
      
      it "should use the values it got as examples" do
        subject.scaffolded_method.request_parameter_named("id").example.should == request_parameters["id"]
        subject.scaffolded_method.request_parameter_named("email").example.should == request_parameters["email"]
        subject.scaffolded_method.request_parameter_named("text").example.should == request_parameters["text"]
      end
      
      it "should stick ??? in the description field" do
        subject.scaffolded_method.request_parameters.map(&:description).should == %w(??? ??? ???)
      end
    end
    
    context "wihout request parameters" do
      before { subject.scaffold_request({}) }

      it "should not have any parameters" do
        subject.scaffolded_method.should have(0).request_parameters
      end
    end
  end
  
  describe "#scaffold_response" do
    subject { described_class.new(method_name) }
    let(:method_name) { "send" }
    
    let(:response_parameters) { { "received_on" => "2011-11-11",
                                  "status" => "sent" } }
    let(:rails_response) { "200 OK" }
    let(:successful) { true }
    
    context "with response parameters" do
      before { subject.scaffold_response(response_parameters, rails_response, successful) }
      
      it "creates placeholder response parameters" do
        subject.scaffolded_method.response_parameter_named("received_on").example.should == "2011-11-11"
        subject.scaffolded_method.response_parameter_named("status").type.should == "String"
      end
      
      it "creates a scaffolded response" do
        subject.scaffolded_method.response_code_for("200 OK", true).should_not be_nil
      end
    end
  end
end