class PictureImportWorker
  @queue = 'low'
  def self.perform(data)
    Picture.new(data).save!
  end
end
