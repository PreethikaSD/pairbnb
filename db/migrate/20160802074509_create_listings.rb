class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
    	t.belongs_to :user, index: true
    	t.string :title
    	t.text :address
    	t.float :price
      	t.timestamps null: false
    end
  end
end
