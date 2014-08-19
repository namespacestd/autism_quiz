class CreateScoreTable < ActiveRecord::Migration
  def up
	create_table :scores do |t|
		t.string :username
		t.string :uuid
		t.integer :score
	end
  end

  def down
  end
end
