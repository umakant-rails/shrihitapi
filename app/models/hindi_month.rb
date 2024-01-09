class HindiMonth < ApplicationRecord
  belongs_to :panchang
  has_many :panchang_tithis, dependent: :destroy
  scope :purshottam_month, ->(){ where(is_purshottam_month: true) }

  MONTH = ['चैत्र', 'बैसाख', 'जयेष्ट', 'अषाढ़', 'श्रावण', 'भाद्रपद', 'अश्विन', 'कार्तिक', 'अगहन', 'पौष', 'माघ', 'फाल्गुन']
  ENG_MONTH = ['जनवरी', 'फरवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितम्बर', 'अक्टूबर', 'नवम्बर', 'दिसम्बर']
	ENG_MONTH_SHORT = ['जन', 'फर', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अग', 'सित', 'अक्टू', 'नव', 'दिस']

  def month_tithis
    month_tithiya = []
    month_tithis = self.panchang_tithis
    month_tithis && month_tithis.each do | tithi |
      month_tithiya.push(tithi.paksh + " " + tithi.tithi.to_s)
    end
    return month_tithiya
  end

end
