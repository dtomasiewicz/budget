def delete_all(*files)
  files.each do |f|
    File.delete f if File.exists? f
  end
end

task :install do
  # build initial database
  Dir.chdir 'db' do
    File.delete 'budget.db' if File.exists? 'budget.db'
    `sqlite3 budget.db ""`
    `sequel -m migrations sqlite://budget.db`
  end

  # build gem
  `gem build budget.gemspec`
  `gem install budget`
end