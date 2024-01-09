class Panchang < ApplicationRecord
	# validates :date, :panchang_tithi, :panchang_month, :paksh, :title,
	# 	:panchang_type, :vikram_samvat, :description, :year, presence: true
	has_many :panchang_tithis, dependent: :destroy
	has_many :hindi_months, dependent: :destroy
	validates :title, :panchang_type, :vikram_samvat, presence: true
	#, :vikram_samvat,

	TYPE = ['राधावल्लभ संप्रदाय']
	# TITHIYA = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]

	def self.get_month_dates(cur_date)
    next_month_wday = cur_date.next_month.beginning_of_month
    next_month_wday += 1.days until next_month_wday.wday == 1
    last_month_wday = cur_date.last_month.beginning_of_month
    last_month_wday += 1.days until last_month_wday.wday == 1

    next_month_link = '/admin/panchangs?start_date='+next_month_wday.strftime("%d/%m/%Y")
    last_month_link = '/admin/panchangs?start_date='+last_month_wday.strftime("%d/%m/%Y")

    return [next_month_link, last_month_link]
	end

	def update_purshottam_month(new_purshottam_month)
		old_purshottam_month = self.hindi_months.where("is_purshottam_month=?", true)[0]

		if new_purshottam_month.length > 0 && old_purshottam_month == nil
			self.hindi_months.create({name: new_purshottam_month, is_purshottam_month: true})
		elsif new_purshottam_month.length > 0 && old_purshottam_month.name != new_purshottam_month
			self.hindi_months.where("is_purshottam_month=?", true).update_all({name: new_purshottam_month})
		elsif old_purshottam_month.present? && new_purshottam_month.length == 0
			self.hindi_months.where("is_purshottam_month=?", true).destroy_all
		end
		self.redefine_month_order
	end

	def redefine_month_order
		pur_month = self.hindi_months.where("is_purshottam_month=?", true)[0]
		month_order = 0

		HindiMonth::MONTH.each do | month |
			month_order = month_order + 1
			month_obj = self.hindi_months.where("name=? and is_purshottam_month=?", month, false)[0]
			month_obj.update({order: month_order})
			if pur_month && month == pur_month.name
				month_order = month_order + 1
				pur_month.update({order: month_order})
			end
		end
	end

end
