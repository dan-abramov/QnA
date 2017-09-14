shared_examples_for 'commentabled' do |attr|
  it 'saves the new comment in the db' do
    expect { post :create, params: { comment: { commentable_type: object.class.name,
                                                commentable_id: object.id, body: 'Comment' },
                                                "#{attr}_id".to_s => object.id, format: :js} }.to change(Comment, :count).by(1)
  end

  it 'render create template' do
    post :create, params: { comment: { commentable_type: object.class.name,
                                       commentable_id: object.id, body: 'Comment' },
                                       "#{attr}_id".to_s => object.id, format: :js}
    expect(response).to render_template :create
  end

  it 'does not save the invalid comment in the db' do
    expect { post :create, params: { comment: { commentable_type: object.class.name,
                                                commentable_id: object.id, body: '' },
                                                "#{attr}_id".to_s => object.id, format: :js} }.to change(Comment, :count).by(0)
  end

end
