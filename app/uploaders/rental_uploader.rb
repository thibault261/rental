# encoding: utf-8
class RentalUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if Rails.env.test?
      "uploads_test/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
    else
      "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"
    end
  end

end
