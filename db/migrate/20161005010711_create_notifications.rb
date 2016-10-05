class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :project
      t.string :target
      t.string :webhook_url
    end
  end
end
