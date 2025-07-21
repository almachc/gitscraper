require 'ostruct'

class ApplicationService
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end

  private

  def success_result(data)
    build_result(success: true, data: data, error: nil)
  end

  def failure_result(error)
    build_result(success: false, data: nil, error: error)
  end

  def build_result(success:, data: nil, error: nil)
    OpenStruct.new(success?: success, data: data, error: error)
  end
end
