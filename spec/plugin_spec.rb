require 'spec_helper'

describe "$mongodb" do
  it "should be present" do
    $mongodb.should be
  end
end

describe File do
  describe :exists? do
    it "should find a filesystem file that exists" do
      File.exists?( "/tmp/rspec/file1.mdown" )
    end
    it "should find a mongo file that exists" do
      File.exists?( "/tmp/rspec/mongo1.mdown" )
    end
  end

  describe :open do
    it "should open a filesystem file for reading" do
      File.open( "/tmp/rspec/file1.mdown", "r" ).read.chomp.should eq "file1.mdown"
    end
    it "should open a mongo file for reading" do
      File.open( "/tmp/rspec/mongo1.mdown", "r" ).read.chomp.should eq "mongo1.mdown body"
    end
    it "should open a filesystem file for writing" do
      File.open( "/tmp/rspec/file2.mdown", "w" ) do |f|
        f.puts "file2.mdown"
      end
      %x{ cat /tmp/rspec/file2.mdown }.chomp.should eq "file2.mdown"
    end
    it "should not write a file to mongo" do
      File.open( "/tmp/rspec/mongo2.mdown", "w" ) do |f|
        f.puts "mongo2.mdown"
      end
      $mongodb.find("_id" => "/tmp/rspec/mongo2.mdown").to_a.size.should eq 0
    end
  end

end
