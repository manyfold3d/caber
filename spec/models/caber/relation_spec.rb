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

    it "gives Alice a list of relations" do
      expect(alice.caber_relations.count).to be 1
    end

    it "gives Alice a list of documents with any sort of permission" do
      expect(alice.permitted_documents.count).to be 1
    end

    it "gives Alice a list of objects she can view" do
      expect(alice.permitted_documents.with_permission("viewer")).to include object
    end

    it "includes Alice in a list of permitted users for the object" do
      expect(object.permitted_users).to include alice
    end

    it "includes Alice in a list of users with viewer permission for the object" do
      expect(object.permitted_users.with_permission("viewer")).to include alice
    end

    it "can get a list of objects that Alice has permission on" do
      expect(Document.granted_to("viewer", alice)).to include object
    end

    it "can get a list of objects that Alice one of many permissions on" do
      expect(Document.granted_to(["viewer", "owner"], alice)).to include object
    end
  end

  context "with multiple objects" do
    let(:object_two) { create :document }

    before do
      object.grant_permission_to "viewer", alice
    end

    it "includes object in Alices permitted object list" do
      expect(alice.permitted_documents.with_permission("viewer")).to include object
    end

    it "does not include second (ungranted) object in Alices permitted object list" do
      expect(alice.permitted_documents.with_permission("viewer")).not_to include object_two
    end

    it "does not include second object in list of objects that Alice has permission on" do
      expect(Document.granted_to("viewer", alice)).not_to include object_two
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

    it "gives Alice a list of objects she can view or own" do
      expect(alice.permitted_documents.with_permission(["viewer", "owner"])).to include object
    end

    it "includes Alice in a list of users with viewer or owner permission for the object" do
      expect(object.permitted_users.with_permission(["viewer", "owner"])).to include alice
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

    # it "includes public objects in Alice's permitted object list" do
    #   expect(alice.permitted_documents.with_permission("viewer")).to eq [object]
    # end
  end

  context "revoking permissions" do
    before do
      object.grant_permission_to "viewer", alice
    end

    it "removes a specific permission" do
      expect { object.revoke_permission("viewer", alice) }
        .to change { alice.has_permission_on?("viewer", object) }.from(true).to(false)
    end

    it "removes all permissions" do
      expect { object.revoke_all_permissions(alice) }
        .to change { alice.has_permission_on?("viewer", object) }.from(true).to(false)
    end
  end

  context "changing permissions" do
    before do
      object.grant_permission_to "viewer", alice
    end

    it "should update the existing permission relation" do
      expect { object.grant_permission_to("editor", alice) }
        .not_to change(Caber::Relation, :count)
    end

    it "should store the new permission" do
      object.grant_permission_to("editor", alice)
      expect(alice.has_permission_on?("editor", object)).to be true
    end

    it "should overwrite the old permission" do
      object.grant_permission_to("editor", alice)
      expect(alice.has_permission_on?("viewer", object)).to be false
    end
  end

  context "removing permissions on object/subject removal" do
    before do
      object.grant_permission_to "viewer", alice
    end

    it "removes permission when subject is removed" do
      expect { alice.destroy }.to change { Caber::Relation.count }.by(-1)
    end

    it "removes permission when object is removed" do
      expect { object.destroy }.to change { Caber::Relation.count }.by(-1)
    end
  end
end
