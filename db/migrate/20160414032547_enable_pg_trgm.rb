class EnablePgTrgm < ActiveRecord::Migration
  def up
    execute %Q{CREATE EXTENSION pg_trgm;}
  end

  def down
    execute %Q{DROP EXTENSION pg_trgm;}
  end
end
