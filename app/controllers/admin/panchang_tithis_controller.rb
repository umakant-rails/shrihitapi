class Admin::PanchangTithisController < ApplicationController
	before_action :authenticate_user!
	before_action :verify_admin
	before_action :set_panchang

	def new 
		current_month = ''
		@panchang.hindi_months.do each | month |
			tithi = month.panchang_tithis.last
			if tithi.tithi !== 15 && tithi.paksh !== "शुक्ळ पक्ष"
				current_month = tithi.hinti_month.name
				break;
			end
		end
		render json: {
			panchang: @panchang,
			active_month: current_month
		}
	end

end
