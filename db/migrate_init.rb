require 'sqlite3'
require 'albino'

FlySouth.runner = Class.new(FlySouth::BaseRunner) do

  def setup(migrations)
    super
    @db = SQLite3::Database.new 'budget_base.db'
  end

  def teardown(error)
    @db.close
    super
  end

  def before_each(migration)
    super
    @db.transaction
  end

  def after_each(error)
    if error
      @db.rollback
    else
      @db.commit
    end
    super
  end

  def execute(*sqls)
    sqls.each do |sql|
      log :info, "Executing SQL:\n#{Albino.colorize(sql, :sql, :terminal)}"
      @db.execute sql
    end
  end

end