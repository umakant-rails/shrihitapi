class PanchangTithi < ApplicationRecord
	belongs_to :panchang
	belongs_to :hindi_month
	validates  :date, :tithi, :paksh, :title, :year, presence: true

	PAKSH = ['कृष्ण पक्ष', 'शुक्ळ पक्ष']
	WEEKDAYS = ["रविवार", "मंगलवार", "रविवार", "बुद्धवार", "बृहस्पतिवार", "शुक्रवार", "शनिवार"]
	TITHIYA = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]

	def self.get_all_tithis
		tithiya = []
		PAKSH.each do | paksh |
			TITHIYA.each do | tithi |
				tithiya.push("#{paksh} #{tithi}")
			end
		end
		return tithiya
	end

	def validate_tithi_entry(last_tithi)
		error = ''

		if last_tithi.present? && (self.paksh == last_tithi.paksh) && (self.tithi-last_tithi.tithi > 1 || self.tithi-last_tithi.tithi < 0)
      # check for tithi must be continue on regular basis for entry in panchang tithi
      error = "कृपया तिथियों को क्रमवार रूप से दर्ज करे, अंतिम दर्ज की गई तिथि
	      #{last_tithi.paksh} #{last_tithi.tithi} है नई तिथि #{last_tithi.paksh} #{self.tithi} के
	      स्थान पर तिथि #{last_tithi.paksh} #{(last_tithi.tithi+1)%15} होनी चाहिए."

    elsif last_tithi.present? && (self.paksh != last_tithi.paksh && self.tithi-last_tithi.tithi != -14)
      # check for tithi must be continue after ending paksh for entry in panchang tithi
      error = "कृपया तिथियों को क्रमवार रूप से दर्ज करे, अंतिम दर्ज की गई तिथि
	      #{last_tithi.paksh} #{last_tithi.tithi} है
	      नई तिथि #{self.paksh} #{self.tithi} के स्थान पर
	      तिथि #{self.paksh} #{(last_tithi.tithi+1)%15} होनी चाहिए."

    elsif last_tithi.present? && ((self.date-last_tithi.date).to_i > 1 || (self.date-last_tithi.date).to_i < 0)
      # check for date must be continue for entry in panchang tithi
      error = "कृपया दिनांक को क्रमवार रूप से दर्ज करे, अंतिम दर्ज की गई दिनांक
	      #{last_tithi.date.strftime('%d/%m/%Y')} है नई दिनांक
	      #{self.date.strftime('%d/%m/%Y')} के स्थान पर तिथि
	      #{(last_tithi.date+1.day).strftime('%d/%m/%Y')} होनी चाहिए"

    elsif PanchangTithi.where("date = ? and tithi = ?", self.date, self.tithi).present?
      error = "इस दिनांक #{self.date.strftime("%d/%m/%Y")} और इस तिथि
			#{self.paksh} #{self.tithi} के साथ एंट्री की जा चुकी है."

    end

    return error

	end

	def self.get_last_tithi(last_tithi)
		tithis = PanchangTithi.joins(:hindi_month).where(date: last_tithi.date)
    if tithis.length > 1
			if tithis.first.hindi_month.order > tithis.last.hindi_month.order
				return tithis.first
			elsif tithis.last.hindi_month.order > tithis.first.hindi_month.order
				return tithis.last
			elsif tithis.first.paksh == 'शुक्ळ पक्ष' && tithis.last.paksh == 'कृष्ण पक्ष'
				return tithis.first
			elsif tithis.last.paksh == 'शुक्ळ पक्ष' && tithis.first.paksh == 'कृष्ण पक्ष'
				return tithis.last
			end
			return last_tithi
		end
		return last_tithi
	end

end
