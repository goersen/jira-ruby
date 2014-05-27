require 'spec_helper'

describe JIRA::RequestCache do
    
  subject {
    JIRA::RequestCache.new(86400000)
  }
  
  let(:now) { Time.now.to_i }
  let(:response) { {"key" => {"data" => "foo", "timestamp" => now}} }
  let(:test_file) { double("test_file", :read => Marshal.dump(response), :write => nil) }
  
  before(:each) do
    File.stub(:exists?) { true }
    Dir.stub(:exists?) { true }
  end

  describe 'load' do

    context "existing cache file" do
      
      before(:each) do
        File.should_receive(:new).with('cache/test_path', 'r+').and_return(test_file)
      end

      it "should create cache dir if not exists" do
        Dir.stub(:exists?) { false }
        FileUtils.should_receive(:mkdir_p).at_least(1).times.with('cache')
        subject.load('test_path')
      end

      it "should load from correct path" do
        subject.load('test_path')
      end

      it "should return the correct result" do
        subject.load('test_path').should == 'foo'
      end

      it "should delete expired entries" do
        Time.should_receive(:now).and_return(double('now', { :to_i => 572349597437239075456456 }))
        File.should_receive(:new).with('cache/test_path', 'w+').and_return(test_file)
        test_file.should_receive(:write).with(Marshal.dump({}))

        subject.load('test_path')
      end
    end

    context "without existing cache file" do

      it "should not try to load file if not exists" do
        File.stub(:exists?) { false }
        File.should_receive(:new).exactly(0).times
        subject.load('test_path')
      end

    end
  end

  describe 'save' do

    before(:each) do
      Time.stub(:now) { double({:to_i  => 42}) }
      File.should_receive(:new).with('cache/test_path', 'r+').and_return(test_file)
      File.should_receive(:new).with('cache/test_path', 'w+').and_return(test_file)
    end

    let(:test_response) { 'bar' }

    it "should load from correct path" do
      subject.save('test_path', test_response)
    end

    it "should save the correct response" do
      expected_cache = {"key" => {"data" => test_response, "timestamp" => 42}}
      test_file.should_receive(:write).with(Marshal.dump(expected_cache))

      subject.save('test_path', test_response)
    end
  end
end