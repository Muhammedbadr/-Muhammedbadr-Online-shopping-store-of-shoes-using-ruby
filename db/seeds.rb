
5.times do |index|
    Category.create!(
        title: "file #{index}"
    )
end
Product.destroy_all
20.times do |index|
  Product.create!(
    name: "product #{index}",
    details: "details #{index}",
    price: index * 50,
    image_url: "0#{1 + index % 8}.jpg", # Removed "products/" prefix here
    size: 1 + index % 3,
    category_id: 1 + index % 5
  )
end
