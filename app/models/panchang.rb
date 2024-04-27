class Panchang < ApplicationRecord
	# validates :date, :panchang_tithi, :panchang_month, :paksh, :title,
	# 	:panchang_type, :vikram_samvat, :description, :year, presence: true
	has_many :panchang_tithis, dependent: :destroy
	has_many :hindi_months, dependent: :destroy
	validates :title, :panchang_type, :vikram_samvat, presence: true
	#, :vikram_samvat,

	TYPE = ['राधावल्लभ संप्रदाय']
	# TITHIYA = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]

	def get_current_month
		month = ''
		tithi = self.panchang_tithis.order("date ASC").last
		if tithi && (tithi.tithi == 15 and tithi.paksh == "शुक्ळ पक्ष")
			month = self.hindi_months.where("id>?", tithi.hindi_month_id).first
		else
			month = tithi.present? ? tithi.hindi_month : @panchang.hindi_months.first
		end
		return month
	end

end
