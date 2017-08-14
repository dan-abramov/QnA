class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "questions/#{params['id']}"
  end
end
