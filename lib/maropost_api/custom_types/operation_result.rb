class OperationResult
  attr_accessor :errors, :success, :data
  def initialize(result)
    if (200..206).to_a.include? result.code
      @success = true
      @errors = nil
      @data = result.parsed_response
    else
      @success = false
      @errors = result.parsed_response
    end
  end
end