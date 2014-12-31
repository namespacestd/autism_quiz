class ChangeScoreTable < ActiveRecord::Migration
  def up
    remove_column :scores, :score
    add_column :scores, :correct, :integer
    add_column :scores, :wrong, :integer
  end

  def down
  end
end
