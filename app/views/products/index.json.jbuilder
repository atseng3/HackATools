json.array!(@products) do |product|
  json.extract! product, :id, :name, :website, :description
  json.url product_url(product, format: :json)
end
