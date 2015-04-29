ActiveRecord::Base.logger = Logger.new STDOUT
head = ["CUSTOMER", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "BILLING ADDRESS", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "DELIVERY ADDRESS", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "HOME PHONE", "", "", "", "", "MOBILE PHONE", "", "", "", "", "WORK PHONE", "", "", "", ""]
header = ["Status", "Customer ID", "Customer Type", "Name", "Last Name", "Title", "Email", "Document", "Gender", "Birthdate", "State Subscription", "Company Representative Name", "OptIn Flag", "Sms OptIn Flag", "Sms Order Tracking OptIn Flag", "Partner OptIn Flag", "Nickname", "Login", "Password", "Salt", "Status", "Recipient Name", "Friendly Name", "Address", "Address Extra 1", "Address Extra 2", "Number", "Building Name", "Floor Number", "Lift", "Intercom", "Additional Info", "Quarter", "City", "State", "Country", "Postal Code", "Reference", "Status", "Recipient Name", "Friendly Name", "Address", "Address Extra 1", "Address Extra 2", "Number", "Building Name", "Floor Number", "Lift", "Intercom", "Additional Info", "Quarter", "City", "State", "Country", "Postal Code", "Reference", "Status", "Country Code", "Area Code", "Number", "Extension", "Status", "Country Code", "Area Code", "Number", "Extension", "Status", "Country Code", "Area Code", "Number", "Extension"]

CSV.open('customer_import.csv', 'wb', encoding: 'iso-8859-1') do |csv|
  User.includes(:addresses).find_each(batch_size: 1000) do |user|
    row = []
    row.push(user.active != false ? 1 : 0) # Status
    row.push(user.id) # Customer ID
    row.push(user.has_corporate ? 1 : 0) # Customer Type
    row.push(user.first_name) # Name
    row.push(user.last_name) # Last Name
    row.push(user.gender == 1 ? 2 : 1) # Title
    row.push(user.email) # Email
    row.push user.has_corporate ? user.cnpj : user.cpf # Document
    row.push(user.gender == 1 ? "M" : "F") # Gender
    row.push(user.birthday) # Birthdate
    row.push user.corporate_name # State Subscription
    row.push user.fantasy_name # Company Representative Name
    row.push(1) # OptIn Flag
    row.push(1) # Sms OptIn Flag
    row.push(1) # Sms Order Tracking OptIn Flag
    row.push(1) # Partner OptIn Flag
    row.push(user.first_name) # Nickname
    row.push(user.email) # Login
    row.push(user.encrypted_password) # Password
    row.push(user.password_salt) # Salt

    address = user.addresses.sort { |a,b| a.last_used_at.to_i <=> b.last_used_at.to_i }.last
    if address.blank?
      2.times { 
        row.push(0)
        17.times { row.push('') }
      }
      3.times {
        row.push(0)
        4.times { row.push('') }
      }
    else
    # Billing Address
    row.push(1) # Status
    row.push("#{address.first_name} #{address.last_name}") # Recipient Name
    row.push(address.first_name) # Friendly Name
    row.push(address.street) # Address
    row.push(address.complement) # Address Extra 1
    row.push('') # Address Extra 2
    row.push(address.number) # Number
    row.push('') # Building Name
    row.push('') # Floor Number
    row.push('') # Lift
    row.push('') # Intercom
    row.push('') # Additional Info
    row.push(address.neighborhood) # Quarter
    row.push(address.city) # City
    row.push(address.state) # State
    row.push(address.country[0,2]) # Country
    row.push(address.zip_code) # Postal Code
    row.push('') # Reference


    # Delivery Address

    row.push(1) # Status
    row.push("#{address.first_name} #{address.last_name}") # Recipient Name
    row.push(address.first_name) # Friendly Name
    row.push("#{address.street}") # Address
    row.push(address.complement) # Address Extra 1
    row.push('') # Address Extra 2
    row.push(address.number) # Number
    row.push('') # Building Name
    row.push('') # Floor Number
    row.push('') # Lift
    row.push('') # Intercom
    row.push('') # Additional Info
    row.push(address.neighborhood) # Quarter
    row.push(address.city) # City
    row.push(address.state) # State
    row.push(address.country[0,2]) # Country
    row.push(address.zip_code) # Postal Code
    row.push('') # Reference

    # Home Phone

    phone = address.telephone
    if /\((?<area_code>[0-9]{2,2})\)(?<number>[0-9-]{9,10})/ =~ phone.to_s

      row.push(1) # Status
      row.push(55) # Country Code
      row.push(area_code)# Area Code
      row.push(number) # Number
      row.push('') # Extension
    else
      row.push(0)
      4.times { row.push('') }
    end


    # Mobile Phone

    phone = address.mobile
    if /\((?<area_code>[0-9]{2,2})\)(?<number>[0-9-]{9,10})/ =~ phone.to_s
      row.push(1) # Status
      row.push(55) # Country Code
      row.push(area_code)# Area Code
      row.push(number) # Number
      row.push('') # Extension
    else
      row.push(0)
      4.times { row.push('') }
    end


    # Work Phone

      row.push(0)
      4.times { row.push('') }
    # Status
    # Country Code
    # Area Code
    # Number
    # Extension
    end

    csv << row
  end
end
