class PictureImporterWorker
  @queue = 'low'
  def self.perform(data, options)
    if options['delete_ids'] && options.delete_ids.to_a.size > 0
      Picture.where(id: options['delete_ids']).destroy_all
    end
    Picture.new(data).save!
  end
end
