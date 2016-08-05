class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :listing, index: true
		t.date :start_date
		t.date :end_date
		t.integer :guest
      t.timestamps null: false
    end
  end
end
