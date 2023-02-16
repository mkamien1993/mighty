module FileHelper
  def upload_file(src, content_type = "image/jpg", binary = false)
    path = Rails.root.join(src)
    original_filename = ::File.basename(path)

    tempfile = Tempfile.open(original_filename) #create a new tempfile

    content = File.open(path).read # Extract content of the original file
    tempfile.write content # Write all content from original file to the tempfile

    Rack::Test::UploadedFile.new(tempfile, content_type, binary, original_filename: original_filename)
  end
end
