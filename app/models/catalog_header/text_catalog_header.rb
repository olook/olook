class CatalogHeader::TextCatalogHeader < CatalogHeader::CatalogHeader
  attr_accessible :resume_title, :text_complement, :title
  validates :resume_title, :text_complement, :title, presence: true
end
