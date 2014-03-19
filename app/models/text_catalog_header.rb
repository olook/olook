class TextCatalogHeader < Header
  attr_accessible :resume_title, :text_complement, :title
  validates :resume_title, :text_complement, :title, presence: true

  def self.model_name
    Header.model_name
  end

  def text?
    true
  end
end
