class CreateAdminMapTypes < ActiveRecord::Migration
  def self.up
    create_table :map_types do |t|
      t.string :name
      t.string :google_map_type
    end
    
    [ ['Street', 'G_NORMAL_MAP'], ['Satellite', 'G_SATELLITE_MAP'], ['Hybrid', 'G_HYBRID_MAP'], ['Terrain', 'G_PHYSICAL_MAP'], ['Earth3D', 'G_SATELLITE_3D_MAP'] ].each do |mt|
      map_type = MapType.new
      map_type.name = mt[0]
      map_type.google_map_type = mt[1]
      map_type.save!
    end
  end

  def self.down
    drop_table :map_types
  end
end
