class TokenMaker
  class << self
    def for(doc)
      type = doc.class.name.upcase
      JsonWebToken.encode({ _id: doc.id.to_s, type: type })
    end
  end
end



