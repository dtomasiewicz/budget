module FlySouth::Migrations

  def init_up
    execute %Q{
      CREATE TABLE accounts (
        id TEXT(10) NOT NULL PRIMARY KEY,
        note TEXT,
        currency TEXT(3) NOT NULL,
        balance INTEGER NOT NULL
      )}

    execute %Q{
      CREATE TABLE debts (
        id TEXT(10) NOT NULL PRIMARY KEY,
        note TEXT,
        currency TEXT(3) NOT NULL,
        principal INTEGER NOT NULL
      )}

    execute %Q{
      CREATE TABLE debt_payments (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        note TEXT,
        debt_id TEXT(10) NOT NULL,
        amount INTEGER NOT NULL,
        time INTEGER NOT NULL
      )}

    execute %Q{
      CREATE TABLE expenses (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        note TEXT,
        currency TEXT(3) NOT NULL,
        amount INTEGER NOT NULL
      )}
  end

  def init_down
    execute "DROP TABLE expenses",
            "DROP TABLE debt_payments",
            "DROP TABLE debts"
            "DROP TABLE accounts"
  end

end