# db/seeds配下に存在する、環境ごとのrbを呼び出す
# db/seeds
# └development.rb
# └production.rb
# └test.rb
load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))
