class CreateCampaingParticipants < ActiveRecord::Migration
  def change
    create_table :campaing_participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :gender
      t.string :campaing
      t.integer :user_id

      t.timestamps
    end
  end
end
