# -*- encoding : utf-8 -*-
  class Report

    FILE_PATH =  "/tmp/"

    attr_reader :csv

    def generate_report(filename = "untitled.csv")
      File.open(FILE_PATH+filename, 'w', :encoding => 'UTF-8') do |file|
        file.write @csv
      end
    end

    def load_csv(filename)
      arr_of_arrs = CSV.read(filename)
    end

=begin
  Itens per customer profile in each of the system profiles
=end

    def generate_purchase_profile_matrix
      report = {:Fashionista => [0,0,0,0,0,0,0,0], :Sexy => [0,0,0,0,0,0,0,0], :Básica => [0,0,0,0,0,0,0,0],
                      :Elegante => [0,0,0,0,0,0,0,0], :Feminina => [0,0,0,0,0,0,0,0], :Tradicional => [0,0,0,0,0,0,0,0],
                      :Trendy => [0,0,0,0,0,0,0,0] }
       Order.where("state <> 'in_the_cart' AND state <> 'waiting_payment' AND state <> 'canceled'").each do |order|
       if order.user != nil
        if !order.user.points.empty?
            user_profile = Profile.find(order.user.profile_scores[0].profile_id)
            order.line_items.each do |ln|
              report[user_profile.name.to_sym][7] = report[user_profile.name.to_sym][7] + 1
              ln.variant.product.profiles.each do |profile|
                idx = 0
                report.each_key do |k|
                  if profile.name.to_sym == k
                    report[user_profile.name.to_sym][idx] = report.fetch(user_profile.name.to_sym)[idx] + 1
                  end
                  idx = idx + 1
                end
              end
            end
          end
       end
      end
      @csv = CSV.generate do |rows|
        rows << %w{X Fashionista Sexy Básica Elegante Feminina Tradicional Trendy Total}
        report.each do |k, v|
          rows << [k.to_s, v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7]]
        end
      end
    end


# { 1982 => [ {:utm_source => 'Google', :usuarios => '1200', :compras => '1000'}, 
#             {:utm_source => 'Facebook', :usuarios => '1200', :compras => '1000'} ]}

def generate_pom_idade
  data = []
  consolidate = []
  birthyear = {}
  utm_sources = []
    Event.where('event_type = 70 AND description IS NOT NULL').each do |event|
      row = ""
      user = User.find(event.user_id)
      if user.birthday != nil && event.description != nil
        row = user.birthday.year.to_s + " - " + event.description
        row = row + "," + '1'
        vendas = 0
        user.orders.each do |order|
          if order != nil
            if order.state != "waiting_payment" && order.state != "in_the_cart" && order.state != "canceled"
              vendas = vendas + 1
            end
          end
        end
        row = row + "," + vendas.to_s
        data << row.clone
      end
    end
   generate_consolidate(data)
end


def extract_utm_source(utm)
  utm = eval(utm)
  if utm != nil
    utm
  end
end


def generate_csv(data)
  @csv = CSV.generate do |rows|
    rows << %w{year-source users purchases}
    data.each do |k, v|
      rows << [k, v[0], v[1]]
    end
  end
end


def generate_consolidate(data)
  consolidate = {}
  @csv = CSV.generate do |rows|
    rows << %w{year source usuarios compras}
    data.each do |dt|
      row = dt.split(",")
      if consolidate.has_key?(row[0])
        consolidate[row[0]] = consolidate[row[0]][0] + row[1].to_i, consolidate[row[0]][1] + row[2].to_i
      else
        consolidate[row[0]] = [row[1].to_i, row[2].to_i]
      end
    end
  end
  generate_csv(consolidate)
end        

# Report of credits for users before the consolidation

def generate_userbase_credit
      #CREDIT_SCORE = 50
      # total_bonus = invite_bonus + used_invite_bonus
      @csv = CSV.generate do |row|
        row << %w{invited_by_email invited_by_total_bonus invited_by_current_bonus
                  invited_by_cpf invited_by_ip accepted_email accepted_name accepted_ip accepted_cpf
                  accepted_created_at accepted_updated_at
                  accepted_total_bonus accepted_current_bonus accepted_used_bonus}
        self.users.each do |id|
             u = User.find(id.to_i)
             u.invites.each do |invite|
              if invite.invited_member != nil
                invitee = invite.invited_member
              row << [u.email, u.invite_bonus + u.used_invite_bonus, u.invite_bonus, u.cpf, u.last_sign_in_ip,
                      invitee.email, invitee.name, invitee.last_sign_in_ip, invitee.cpf, invitee.created_at,
                      invitee.updated_at, invitee.invite_bonus + invitee.used_invite_bonus,
                      invitee.invite_bonus, invitee.used_invite_bonus]
              end
            end
        end
      end
    end

# Report of credits for users after consolidation

def generate_userbase_credit_new
  @csv = CSV.generate do |row|
    row << %w{email name before_removal_total_bonus before_removal_current_bonus
            cpf ip after_removal_current_bonus}
    load_csv("/home/felipe/projetos/olook/lib/users_to_check.csv").each do |r|
      u = User.find_by_email(r[0])
      if u != nil
        row << [r[0], u.name, r[1], r[2], r[3], r[4], u.current_credit]
      end
    end
  end
end

    

def cpf_normalize(cpf)
  if cpf.count("0-9") < 11
    zeros = ""
    cpf.count("0-9").upto(11) do 
      zeros = zeros + "0"
    end
    cpf = zeros + cpf
  end
  cpf
end

def cpfs_to_analyze
  @csv = CSV.generate do |row|
    row << %w{invited_by_email invited_by_total_bonus invited_by_current_bonus
              invited_by_cpf invited_by_ip accepted_email accepted_name accepted_ip accepted_cpf
              accepted_created_at accepted_updated_at
                accepted_total_bonus accepted_current_bonus accepted_used_bonus}
    self.users.each do |id|
      u = User.find(id.to_i)
      u.invites.each do |invite|
        if invite.invited_member != nil
          cpf_found = false
          invitee = invite.invited_member
          analyzed_cpfs.each do |cpf|
            if invitee.cpf.gsub(".","").gsub("-","").include?(cpf)
              cpf_found = true
            end 
          end
          if cpf_found == false
            row << [u.email, u.invite_bonus + u.used_invite_bonus, u.invite_bonus, u.cpf, u.last_sign_in_ip,
              invitee.email, invitee.name, invitee.last_sign_in_ip, invitee.cpf, invitee.created_at,
              invitee.updated_at, invitee.invite_bonus + invitee.used_invite_bonus,
              invitee.invite_bonus, invitee.used_invite_bonus]
          end
        end
      end
    end
  end
end


end
