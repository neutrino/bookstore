require "rails_helper"

RSpec.describe Book, type: :model do
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:year_published) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "attributes" do
    it "has title, year_published, authors, description, and user attributes" do
      book = FactoryBot.create(:book,
        title: "Sample Book",
        year_published: 2022,
        authors: "John Doe",
        genre: "History",
        description: "A sample book description.")
      expect(book.title).to eq("Sample Book")
      expect(book.year_published).to eq(2022)
      expect(book.authors).to eq("John Doe")
      expect(book.genre).to eq("History")
      expect(book.description).to eq("A sample book description.")
    end
  end

  describe "published_year" do
    it "should validates the year published between 1900 and current year" do
      book = FactoryBot.build(:book, year_published: 1899)
      expect(book.valid?).to be false
    end

    it "should shouldn't allow to add future values in a published-date" do
      book = FactoryBot.build(:book, year_published: Time.now.year + 1)
      expect(book.valid?).to be false
    end
  end

end