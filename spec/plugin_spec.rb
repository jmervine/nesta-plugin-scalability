require "spec_helper"

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
    it "should open a mongo file as well" do
      $mongodb.find("_id" => "/tmp/rspec/file2.mdown").to_a.size.should eq 1
      $mongodb.find("_id" => "/tmp/rspec/file2.mdown").to_a.first["body"].chomp.should eq "file2.mdown"
    end
    it "should update a filesystem file if present" do
      File.open( "/tmp/rspec/file2.mdown", "w" ) do |f|
        f.puts "file2.mdown again"
      end
      %x{ cat /tmp/rspec/file2.mdown }.chomp.should eq "file2.mdown again"
    end
    it "should update a mongo file if present" do
      $mongodb.find("_id" => "/tmp/rspec/file2.mdown").to_a.size.should eq 1
      $mongodb.find("_id" => "/tmp/rspec/file2.mdown").to_a.first["body"].chomp.should eq "file2.mdown again"
    end
  end

  describe :delete do
    it "should delete a filesystem file" do
      File.delete "/tmp/rspec/file2.mdown"
      system("test -e /tmp/rspec/file2.mdown").should be_false
    end
    it "should delete a mongo file as well" do
      $mongodb.find("_id" => "/tmp/rspec/file2.mdown").to_a.size.should eq 0
    end
  end

  describe :last_modified do
    it "should get mtime of filesystem file" do
      File.last_modified("/tmp/rspec/file1.mdown").should be_a Time
      File.last_modified("/tmp/rspec/file1.mdown").to_i.should >= START_TIME.to_i
    end
    it "should get mtime of mongo file" do
      File.last_modified("/tmp/rspec/mongo1.mdown").should be_a Time
      File.last_modified("/tmp/rspec/mongo1.mdown").to_i.should >= START_TIME.to_i
    end
  end
end

