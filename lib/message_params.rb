class MessageParams
  def self.generate(raw_params)
    fp = file_params(raw_params.delete(:file))
    raw_params.merge(fp)
  end

  def self.file_params(file)
    unless file.nil?
      {
        file_contents: file.read,
        file_extension: File.extname(file.original_filename).sub(".", ""),
      }
    else
      {}
    end
  end
end
