module FactoryBot
  # The receiver for callbacks and the fallback receiver inside attribute
  # blocks, so `create(:post)` and `generate(:email)` work without a prefix.
  class SyntaxRunner
    include Syntax::Methods
  end
end
