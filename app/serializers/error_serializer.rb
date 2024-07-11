class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def serialize_json
    {
      data:[],
        error: [
          {
            status: @error_object.status_code.to_s,
            title: @error_object.message
          }
        ]
    }
  end
end