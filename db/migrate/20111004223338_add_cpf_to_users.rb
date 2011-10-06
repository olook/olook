# -*- encoding : utf-8 -*-
class AddCpfToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cpf, :string
  end
end
