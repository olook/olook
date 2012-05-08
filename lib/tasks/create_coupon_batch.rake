 # -*- encoding: utf-8 -*-
namespace :coupons do 
  desc "Create coupons batch from csv file. Accepts filename, col_separator and fields to exclude"
  task :create_batch, [:filename, :col_sep] => :environment do |t, args|
    csv = CSV.read(args[:filename], {:headers => true,  :header_converters => :symbol , :col_sep => args[:col_sep]})
    begin
      check_csv_syntax(csv.headers.collect {|h| h.downcase})
      csv.each do |row|
    	 Coupon.create(:code => row[:code], :is_percentage => row[:is_percentage], :value => row[:value], 
    	 :start_date => row[:start_date], :end_date => row[:end_date], :remaining_amount => row[:remaining_amount], 
       :unlimited => row[:unlimited], :active => row[:active] )
      end
    rescue Exception => e
      puts "Unable to process your request: #{e.message}"
    end
  end

  private
  def check_csv_syntax(header)
    excluded_fields = [:created_at, :updated_at, :id, :used_amount]
    fields = Coupon.column_names.collect{ |col| col.to_sym } - excluded_fields
    raise "the provided CSV has the following fields: #{header.collect{|f| f.to_s}.join("|")}. 
    To work, please change to the following fields #{fields.collect{|f| f.to_s}.join("|")}." if header.sort != fields.sort
  end

end	