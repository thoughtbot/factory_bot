# Definition file paths

Factories can be defined anywhere, but will be automatically loaded after
calling `FactoryBot.find_definitions` if factories are defined in files at the
following locations:

    factories.rb
    factories/**/*.rb
    test/factories.rb
    test/factories/**/*.rb
    spec/factories.rb
    spec/factories/**/*.rb
