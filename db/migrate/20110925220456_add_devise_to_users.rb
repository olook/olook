class AddDeviseToUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.recoverable
      t.rememberable
      t.trackable
      t.encryptable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      t.string :encrypted_password, :null => false, :default => '', :limit => 128
    end

    add_index :users, :unlock_token, :unique => true
  end

  def self.down
    change_table :users do |t|
      t.remove :reset_password_token
      t.remove :reset_password_sent_at
      t.remove :remember_created_at
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      t.remove :current_sign_in_ip
      t.remove :last_sign_in_ip
      t.remove :password_salt
      t.remove :failed_attempts
      t.remove :unlock_token
      t.remove :locked_at
      t.remove :encrypted_password 
    end
  end
end
