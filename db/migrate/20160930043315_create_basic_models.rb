class CreateBasicModels < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :slug
      t.string :repo
      t.string :github_user, null: true
    end

    create_table :batches do |t|
      t.references :project
      t.string :environment
      t.string :page_name
      t.string :url
      t.string :bs_job_id
      t.timestamps
    end

    create_table :snaps do |t|
      t.references :batch
      t.jsonb :bs_platform_atts
      t.string :thumb_url
      t.string :image_url
    end
  end
end
