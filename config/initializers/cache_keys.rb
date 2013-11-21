CACHE_KEYS = {
  product_item_partial_shoe: { key: '_product_item:%s|shoe_size:%s', expire: 30*60 },
  product_item_partial: { key: '_product_item:%s', expire: 30*60 },
  lite_product_item_partial_shoe: { key: '_lite_product_item:%s|shoe_size:%s', expire: 30*60 },
  lite_product_item_partial: { key: '_lite_product_item:%s', expire: 30*60 },
  product_colors: { key: "p:colors:%s:%s", expire: 30*60 },
  product_clothes_for_profile: { key: "SR:%s", expire: 10*60 },
  product_search: { key: "ps:%s", expire: 10*60*60 },
  detail_color: { key: "detail:colors:%s", expire: 30*60 },
  all_brands: {key: "all_brands", expire: 8*60*60},
  all_subcategories: {key: "all_subcategories", expire: 8*60*60},
  all_categories: {key: "all_categories", expire: 8*60*60}
}
