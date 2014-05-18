Gem::Specification.new do |s|
  s.name = "pirata"
  s.version = "0.1.5"
  s.date = "2014-05-18"
  s.summary = "Pirata - a Ruby API for The Pirate Bay"
  s.authors = ["Colin Lindsay"]
  s.email = "clindsay107@gmail.com"
  s.homepage = "https://github.com/clindsay107/Pirata"
  s.files = ["lib/pirata.rb", "lib/pirata/search.rb", "lib/pirata/category.rb", "lib/pirata/sort.rb", "lib/pirata/config.rb", "lib/pirata/torrent.rb", "lib/pirata/user.rb"]
  s.require_paths = ["lib", "lib/pirata"]
  s.license = "GPL"
  s.description = "A Ruby gem that exposes an API for using The Pirate Bay torrent tracker service."
  s.add_dependency "nokogiri"
end