Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each do |seed|
  require seed
end
