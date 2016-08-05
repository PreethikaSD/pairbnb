class CreateAvailableDates < ActiveRecord::Migration
  def change
    create_table :available_dates do |t|
    	t.belongs_to :listing, index: true
    	t.date :booked_date
    	t.boolean :available 
        t.timestamps null: false
    end
  end
end
