require "rails_helper"

RSpec.describe Caber::Relation, :multiuser do
  let(:alice) { create(:user) }
  let(:bob) { create(:user) }
  let(:object) { create(:document) }

  context "when Alice can view a object" do
    before do
      object.grant_permission_to "viewer", alice
    end

    it "confirms that Alice is a viewer of the object" do
      expect(alice.has_permission_on?("viewer", object)).to be true
    end

    it "confirms that the object has granted viewer permission to Alice" do
      expect(object.grants_permission_to?("viewer", alice)).to be true
    end

    it "confirms that Bob is NOT a viewer" do
      expect(bob.has_permission_on?("viewer", object)).to be false
    end

    it "confirms that the object has not granted global viewer permission" do
      expect(object.grants_permission_to?("viewer", nil)).to be false
    end
  end

  context "checking more than one permission at once" do
    before do
      object.grant_permission_to "viewer", alice
    end

    it "confirms that alice has been given one of viewer or owner permission" do
      expect(object.grants_permission_to?(["viewer", "owner"], alice)).to be true
    end

    it "confirms that alice has one of viewer or owner permission" do
      expect(alice.has_permission_on?(["viewer", "owner"], object)).to be true
    end

    it "confirms that alice doesn't have either of editor or owner permission" do
      expect(object.grants_permission_to?(["editor", "owner"], alice)).to be false
    end
  end

  context "when anyone can view a object" do
    before do
      object.grant_permission_to "viewer", nil
    end

    it "confirms that the object has been granted global viewer permission" do
      expect(object.grants_permission_to?("viewer", nil)).to be true
    end

    it "confirms that Alice is a viewer of the object" do
      expect(alice.has_permission_on?("viewer", object)).to be true
    end

    it "confirms that Bob is also a viewer" do
      expect(bob.has_permission_on?("viewer", object)).to be true
    end
  end
end
