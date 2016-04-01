namespace :api_keys do
  desc 'Generate a new ApiKey record'
  task generate: :environment do
    puts 'Generating a new ApiKey record...'
    gen = ApiKey.generate!
    puts "Generated ApiKey key -> #{gen.key}"
  end
end
