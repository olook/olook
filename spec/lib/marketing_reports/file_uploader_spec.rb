# -*- encoding : utf-8 -*-

describe MarketingReports::FileUploader do
  let(:file_content) { "This is an Example String" }

  subject { described_class.new(file_content) }

  describe "#copy_to_ftp" do
    let(:ftp_server_config) { %w{hftp.olook.com.br allinmail allinmail123abc} }
    let(:connection) { double(:ftp_connection) }
    let(:file) { double(:file, :path => "tmp/temp_name.csv", :write => "") }


   it "opens a new ftp connection to hftp.olook.com.br using the correct username and password" do
     Net::FTP.should_receive(:new).with(*ftp_server_config).and_return(mock.as_null_object)
     subject.copy_to_ftp(anything)
   end

   it "sets ftp connection to passive mode" do
     Net::FTP.stub(:new).and_return(connection)
     connection.stub(:close)
     connection.stub(:puttextfile)

     connection.should_receive(:passive=).with(true)
     subject.copy_to_ftp
   end

   context "creating the file" do
     before do
       Net::FTP.stub(:new).and_return(mock.as_null_object)
     end

     it "creates a new temporary file in the tmp dir" do
       file.stub(:write)
       Tempfile.should_receive(:open).with("/tmp/", "w", :encoding => "ISO-8859-1").and_yield(file)
       subject.copy_to_ftp
     end

     it "writes the received string to the tempfile" do
       Tempfile.stub(:open).and_yield(file)
       file.should_receive(:write).with(file_content)
       subject.copy_to_ftp
     end
   end


   context "copying the file" do
     let(:filename) { "file.csv" }
     before do
       Net::FTP.stub(:new).and_return(connection)
       connection.stub(:close)
       connection.stub(:passive=)
     end

     it "uses untitled.txt as filename when no name is passed" do
       connection.should_receive(:puttextfile).with(anything, "untitled.txt")
       subject.copy_to_ftp
     end

     it "uses received name as filename" do
       connection.should_receive(:puttextfile).with(anything, filename)
       subject.copy_to_ftp(filename)
     end

     it "puts the created temp file in the ftp server" do
       Tempfile.stub(:open).and_yield(file)
       connection.should_receive(:puttextfile).with(file.path, filename)
       subject.copy_to_ftp(filename)
     end

   end

   it "closes the ftp connection" do
     Net::FTP.stub(:new).and_return(connection)
     connection.stub(:puttextfile)
     connection.stub(:passive=)

     connection.should_receive(:close)
     subject.copy_to_ftp
   end
 end

end