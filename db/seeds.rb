5.times do |index|   # تقوم بتكرار الكود 5 مرات
    Category.create!(   # إنشاء سجل جديد في جدول الفئات
      title: "الصنف   #{index}"  # تعيين العنوان ليكون "الصنف 0", "الصنف 1", وهكذا
    )
  end
  
  
  20.times do |index|
    Product.create!(
      name: "المنتج #{index}",
      details: "تفاصيل المنتج #{index}",
      price: index * 50,
      image_url: "products/0#{(1 + index % 8)}.jpg", # Added comma here
      size: 1 + index % 3,
      category_id: 1 + index % 5
    )
  end
  