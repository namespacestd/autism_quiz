class CreateTestTable < ActiveRecord::Migration
  def change
    create_table :test_tables do |t|
    end
  end
end
