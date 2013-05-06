Gem::Specification.new do |s|
  s.name        = 'budget'
  s.version     = '0.0.0'
  s.date        = '2013-05-06'
  s.summary     = 'Command-line budgeting tool.'
  s.description = s.summary

  s.author      = 'Daniel Tomasiewicz'
  s.email       = 'me@dtomasiewicz.com'
  s.homepage    = 'http://github.com/dtomasiewicz/budget'

  s.files       = Dir['{bin,lib}/**/*', 'db/budget_base.db', 'README*', 'LICENSE']
  s.executables << 'budget'
  s.add_dependency 'rake'
  s.add_dependency 'fly_south'
end