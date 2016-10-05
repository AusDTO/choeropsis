class AddAuthToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.string :basic_auth, null: true
    end
  end
end
