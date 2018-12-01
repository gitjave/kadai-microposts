(1..100).each do |number|
  User.first.microposts.create(content: 'hello')
end