module Banker
module Session

class Base
  def initialize(credentials = nil)
    open(credentials) if credentials
  end

  def open(credentials)
  end

  def close
  end
end

end  
end

