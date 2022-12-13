require "rails_helper"

RSpec.describe Project, type: :model do
  subject { FactoryBot.create(:project) }

  it { should have_many(:projects).dependent(:destroy) }
  it { should validate_presence_of(:title) }
  it { should have_many(:stories) }
  it { should belong_to(:parent) }

  it "does not set a position if not a sub project" do
    parent = FactoryBot.create(:project)
    expect(parent.position).to be_nil
  end

  it "sets a position scoped within a parent" do
    parent = FactoryBot.create(:project)
    sub_project1 = FactoryBot.create(:project, parent: parent)
    sub_project2 = FactoryBot.create(:project, parent: parent)
    expect(sub_project1.position).to eq 1
    expect(sub_project2.position).to eq 2
  end

  describe ".with_ordered_descendents" do
    it "orders sub projects properly" do
      parent = FactoryBot.create(:project)
      sub_project1 = FactoryBot.create(:project, parent: parent, position: 2)
      story_5 = FactoryBot.create(:story, project: sub_project1, position: 2)
      story_4 = FactoryBot.create(:story, project: sub_project1, position: 1)
      story_6 = FactoryBot.create(:story, project: sub_project1, position: 3)
      sub_project2 = FactoryBot.create(:project, parent: parent, position: 1)
      story_3 = FactoryBot.create(:story, project: sub_project2, position: 3)
      story_1 = FactoryBot.create(:story, project: sub_project2, position: 1)
      story_2 = FactoryBot.create(:story, project: sub_project2, position: 2)
      sub_projects = Project.sub_projects_with_ordered_stories(parent.id)

      expect(sub_projects.count).to eq 2
      expect(sub_projects[0].id).to eq sub_project2.id
      expect(sub_projects[0].stories[0].id).to eq story_1.id
      expect(sub_projects[0].stories[1].id).to eq story_2.id
      expect(sub_projects[0].stories[2].id).to eq story_3.id
      expect(sub_projects[1].id).to eq sub_project1.id
      expect(sub_projects[1].stories[0].id).to eq story_4.id
      expect(sub_projects[1].stories[1].id).to eq story_5.id
      expect(sub_projects[1].stories[2].id).to eq story_6.id
    end
  end

  def add_sub_project
    FactoryBot.create(:project, parent: subject, status: subject.status)
  end
end
