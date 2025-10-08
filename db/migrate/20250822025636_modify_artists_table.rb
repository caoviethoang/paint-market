class ModifyArtistsTable < ActiveRecord::Migration[7.2]
  def change
    # Xóa cột DOB
    remove_column :artists, :dob, :date
    
    # Thêm cột start_work (năm) nếu chưa có
    unless column_exists?(:artists, :start_work)
      add_column :artists, :start_work, :integer
    else
      # Nếu đã có cột start_work, thay đổi kiểu dữ liệu với USING clause để trích xuất năm
      change_column :artists, :start_work, :integer, using: 'EXTRACT(YEAR FROM start_work)::integer'
    end
    
    # Thêm index cho start_work để tìm kiếm nhanh hơn
    add_index :artists, :start_work unless index_exists?(:artists, :start_work)
  end
end
