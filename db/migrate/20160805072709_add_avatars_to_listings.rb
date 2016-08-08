class AddAvatarsToListings < ActiveRecord::Migration
  def change
  	add_column :listings, :avatars, :string, array: true, default: []
  end
end
