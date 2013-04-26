class AddAdminToUsers < ActiveRecord::Migration
  def change
    # without default: false argument, admin will be nil by default, which is still false
    # so adding default is not strictly recessary
    add_column :users, :admin, :boolean, default: false
  end
end
