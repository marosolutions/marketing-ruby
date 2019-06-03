class OperationResult
  attr_accessor :errors, :success, :data
  def initialize(result)
    if (200..206).to_a.include? result.code
      @success = true
      @errors = nil
      @data = JSON.parse([result.body].to_json).first
      @data = JSON.parse(@data) if @data.kind_of? String and @data.start_with?("{", "[")
      @data = nil if @data == ""
    else
      @success = false
      @errors = JSON.parse(JSON.parse([result.body].to_json).first) if result.code != 404
      @errors = nil if @errors == ""
      @errors['message'] = 'Page not found!' if result.code == 404
    end
  end
end