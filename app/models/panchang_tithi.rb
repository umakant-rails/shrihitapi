class PanchangTithi < ApplicationRecord
	belongs_to :panchang
	belongs_to :hindi_month
	validates  :date, :tithi, :paksh, :title, :year, presence: true

	PAKSH = ['कृष्ण पक्ष', 'शुक्ळ पक्ष']
	WEEKDAYS = ["रविवार", "मंगलवार", "रविवार", "बुद्धवार", "बृहस्पतिवार", "शुक्रवार", "शनिवार"]
	TITHIYA = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
end
