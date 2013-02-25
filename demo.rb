class FundingRoundCommand

  include Pymn::COR

  def presenter_for feed_object
    FundingRoundPresenter.new(feed_object)
  end

  responsibility :presenter_for { |feed_object| feed_object.class == FundingRound }
end

class FundingRoundPresenter
  include Pymn::COR

  def self.presenter_for feed_object
    new(feed_object)
  end

  factory_responsibility :presenter_for { |feed_object| feed_object.class == FundingRound }
end

class FeedPresenter
  def initialize
    @cor = FundingRoundCommand
    @cor.add StatusUpdateCommand
    @cor.add ConversationMessageCommand
  end

  def dothing feed_object
    @cor.presenter_for(feed_object)
  end
end

