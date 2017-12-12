class Response::ApiResponse
  attr_accessor :success, :errMsg

  def initialize
    @success = true
    @errMsg = ''
  end

  def setErrMsg(pass_errMsg)
    @success = false
    @errMsg = pass_errMsg
  end
end