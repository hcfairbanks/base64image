json.extract! document, :id, :doc_name, :user_id, :created_at, :updated_at
json.url document_url(document, format: :json)
