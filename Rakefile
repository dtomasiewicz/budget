def delete_all(*files)
  files.each do |f|
    File.delete f if File.exists? f
  end
end

task :install do
  # build initial database
  Dir.chdir 'db' do
    delete_all 'budget_base.db', 'migrate_version'
    `migrate -l`
  end

  # build gem
  `gem build budget.gemspec`
  `gem install budget`
end