class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :booking, index: true
    	t.boolean :paid
    	t.float :amount
    	    	
      t.timestamps null: false
    end
  end
end
