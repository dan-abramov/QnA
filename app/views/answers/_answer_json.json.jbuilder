json.extract! answer, :id, :question_id, :user_id, :body, :rating, :best

json.question_user_id answer.question.user_id

json.attachments answer.attachments do |attachment|
  json.id attachment.id
  json.file_name attachment.file.identifier
  json.file_url attachment.file.url
end
