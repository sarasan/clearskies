# Map share IDs and access code IDs to the proper share
module IDMapper
  # Go through each known share and access code.  Block will be given the
  # share_id (or code_id) and peer_id.
  def self.each
    Shares.each do |share|
      yield share.id, share.peer_id
      share.each_code do |code|
        yield code.id, share.peer_id
      end
    end

    PendingCodes.each do |code|
      yield code.id, code.peer_id
    end
  end

  # returns share, code or nil
  def self.find id
    Shares.each do |share|
      return share, nil if share.id == id
      share.each_code do |code|
        return share, code if code.id == id
      end
    end

    PendingCodes.each do |code|
      return nil, code if code.id == id
    end

    return nil, nil
  end
end
