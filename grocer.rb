def consolidate_cart(cart)
  consolidated = {}
  cart.each do |item|
    value = consolidated[item.keys[0]] ||= item.values[0].clone
    value[:count] = value[:count].to_i + 1
  end
  consolidated
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(item_name = coupon[:item]) && cart[item_name][:count] >= coupon[:num]
      cart[coupon_item = "#{item_name} W/COUPON"] ||= cart[item_name].clone.update(count: 0, price: coupon[:cost] / coupon[:num])
      cart[item_name][:count] -= coupon[:num]
      cart[coupon_item][:count] += coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each {|item, value| value[:price] = (value[:price] * 0.8).round(2) if value[:clearance]}
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  apply_coupons(consolidated_cart, coupons)
  apply_clearance(consolidated_cart)
  total = 0
  consolidated_cart.each do |item, value|
    total += value[:price] * value[:count]
  end
  total >= 100 ? total * 0.9 : total
end
