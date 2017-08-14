class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stream_from "questions/#{params['id']}/comments"
  end
end
