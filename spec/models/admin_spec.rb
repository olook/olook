# == Schema Information
#
# Table name: admins
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  encrypted_password  :string(128)      default(""), not null
#  failed_attempts     :integer          default(0)
#  unlock_token        :string(255)
#  locked_at           :datetime
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  remember_created_at :datetime
#  created_at          :datetime
#  updated_at          :datetime
#  first_name          :string(255)
#  last_name           :string(255)
#  role_id             :integer
#

# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admin do
  context "checking roles" do
    it "should check for a existing role" do
      admin = FactoryGirl.create(:admin_superadministrator)
      admin.has_role?(:superadministrator).should eq(true)
    end
  end
end
