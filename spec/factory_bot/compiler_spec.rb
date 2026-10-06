describe FactoryBot::Compiler do
  before { define_class("User") { attr_accessor :name, :role, :email } }

  def compile(name, *traits)
    described_class.compile(FactoryBot.factories.find(name), traits)
  end

  it "merges attributes parent, base traits, own, runtime traits, keeping declaration order" do
    FactoryBot.define do
      factory :user do
        name { "parent" }
        email { "parent@example.com" }
        trait(:base) { name { "base" } }
        trait(:runtime) { email { "runtime@example.com" } }

        factory :child, traits: [:base] do
          role { "child" }
        end
      end
    end

    compiled = compile(:child, :runtime)

    expect(compiled.attributes.keys).to eq [:name, :email, :role]
    expect(compiled.attributes[:name].block.call).to eq "base"
    expect(compiled.attributes[:email].block.call).to eq "runtime@example.com"
  end

  it "resolves trait references in the scope of the factory being built" do
    FactoryBot.define do
      factory :user do
        trait(:great) { name { "great" } }
        trait(:make_it_great) { great }

        factory :greatest_user do
          trait(:great) { name { "greatest" } }
        end
      end
    end

    expect(compile(:user, :make_it_great).attributes[:name].block.call).to eq "great"
    expect(compile(:greatest_user, :make_it_great).attributes[:name].block.call).to eq "greatest"
  end

  it "caches compiled factories until the definitions change" do
    FactoryBot.define { factory :user }

    first = compile(:user)
    expect(compile(:user)).to be first

    FactoryBot.modify { factory(:user) { name { "x" } } }
    expect(compile(:user)).not_to be first
  end

  it "raises on circular trait references" do
    FactoryBot.define do
      factory :user do
        trait(:a) { b }
        trait(:b) { a }
      end
    end

    expect { compile(:user, :a) }
      .to raise_error(FactoryBot::TraitDefinitionError, "Circular trait reference: a -> b -> a")
  end

  it "raises on duplicate attributes within one definition" do
    FactoryBot.define do
      factory :user do
        name { "a" }
        name { "b" }
      end
    end

    expect { compile(:user) }
      .to raise_error(FactoryBot::AttributeDefinitionError, "Attribute already defined: name")
  end
end
