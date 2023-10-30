# frozen_string_literal: true

class CreatePastes < ActiveRecord::Migration[6.1]
  def change
    create_table :pastes do |t|
      t.belongs_to :user
      t.string :name
      t.text :content, null: false
      t.string :language
      t.boolean :private, null: false, default: false

      t.timestamps
    end
  end
end
