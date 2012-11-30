require 'rake'

Gem::Specification.new do |s|
  s.name        = 'realiaser'
  s.version     = '0.0.2'
  s.date        = '2012-11-30'
  s.summary     = "Realiaser is a game which helps you memorize your shell aliases."
  s.description = "Adds a feedback look and gamifies your shell usage to help you learn your aliases."
  s.authors     = ["Paul McKellar"]
  s.email       = 'paul.mckellar@gmail.com'
  s.files       = FileList['lib/**/*.rb',
                           'lib/*.rb',
                           'bin/*',
                           '[A-Z]*',
                           'test/**/*'].to_a
  s.homepage    = 'https://github.com/paulmars/realiaser'
  s.executables << 'realiaser'
end
