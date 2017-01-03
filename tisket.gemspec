Gem::Specification.new do |s|
  s.name          = 'tisket'
  s.version       = '0.1.3'
  s.date          = '2016-12-30'
  s.summary       = 'Tisket'
  s.description   = 'Simple Ruby workflow executor'
  s.homepage      = 'https://github.com/mpabst/tisket'
  s.authors       = %w[ Michael Pabst ]
  s.email         = 'michael.k.pabst@gmail.com'
  s.license       = 'CC-BY-NC-SA-4.0'
  s.files         = Dir['lib/*.rb'] + Dir['lib/tisket/*.rb']
  s.require_paths = %w[ lib ]
end
