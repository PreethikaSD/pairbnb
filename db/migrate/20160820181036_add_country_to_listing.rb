class AddCountryToListing < ActiveRecord::Migration
  def change
  	add_column :listings, :country_name, :string
  end
end
