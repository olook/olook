# -*- encoding : utf-8 -*-
FactoryGirl.define do
	factory :authorized, class: OrderStateTransition do
		event 'authorized'
		to    'authorized'
	end
end