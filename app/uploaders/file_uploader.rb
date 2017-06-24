class FileUploader < CarrierWave::Uploader::Base
  storage :file #означает что файлы хранятся локально

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
