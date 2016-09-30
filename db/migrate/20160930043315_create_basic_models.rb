class CreateBasicModels < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :slug
    end

    create_table :environments do |t|
      t.references :project
      t.string :name
      t.string :slug
      t.string :domain
    end

    create_table :pages do |t|
      t.references :project
      t.string :path
      t.boolean :ssl, null: false, default: false
    end

    create_table :platforms do |t|
      t.references :project
      t.string :os
      t.string :os_version
      t.string :browser
      t.string :browser_version
    end

    create_table :batches do |t|
      t.references :environment
      t.string :bs_job_id
      t.timestamps
    end

    create_table :snaps do |t|
      t.references :batch
      t.references :page
      t.references :platform
      t.string :thumb_url
      t.string :image_url
    end
  end
end
