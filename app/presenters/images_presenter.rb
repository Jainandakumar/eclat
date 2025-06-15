class ImagesPresenter
  def initialize(image_object)
    @image_object = image_object
  end

  def get_image(size = "100x100")
    if @image_object.attached? && @image_object.content_type != "application/pdf"
      @image_object.variant(resize: size)
    else
      nil
    end
  end
end