  # This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or create!d alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create!([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create!(name: "Luke", movie: movies.first)
Role.create!(name: 'Super Admin') if Role.where(name: 'Super Admin').blank?
Role.create!(name: 'Admin') if Role.where(name: 'Admin').blank?
Role.create!(name: 'Contributor') if Role.where(name: 'Contributor').blank?

state_list = ["Arunachal Pradesh", "Himachal Pradesh", "Jammu & Kashmir", "Andhra Pradesh", "Madhya Pradesh",
  "Uttar Pradesh", "Chhattisgarh", "Maharashtra", "West Bengal", "Uttarakhand", "Rajasthan",
  "Tamilnadu", "Telangana", "Meghalaya", "Jharkhand", "Karnatka", "Hariyana", "Nagaland",
  "Tripura", "Manipur", "Punjab", "Gujrat", "Kerala", "Sikkim", "Delhi", "Bihar", "Udisa", "Asam"
]
state_list.each do | state | 
  State.create!(name: state) if State.where(name: state).blank?
end 

article_type_list = ['पद', 'कवित्त', 'सवैया', 'दोहा', 'भजन', 'अन्य','सोरठा' ]
article_type_list.each do | article_type | 
  ArticleType.create!(name: article_type, user_id: 1) if ArticleType.where(name: article_type).blank?
end


Theme.create!(name: 'व्याहुला', user_id: 1) if Theme.where(name: 'व्याहुला').blank?
Theme.create!(name: 'जन्मोत्सव', user_id: 1) if Theme.where(name: 'जन्मोत्सव').blank?
Theme.create!(name: 'होली', user_id: 1) if Theme.where(name: 'होली').blank?
Theme.all.each{ | theme |
  ThemeChapter.create(user_id:1, theme_id: theme.id, name: "#{theme.name} अध्याय") if ThemeChapter.where(name: "#{theme.name}_विविध _प्रकरण").blank?
}

context_list = ['अन्य', 'वन विहार', 'श्रृंगार', 'शरद ऋतु', 'वर्षा ऋतु', 'नौका विहार']
context_list.each do | context | 
  Context.create!(name: context, is_approved: true, user_id: 1) if Context.where(name: context).blank?
end

sampradaya_list = ['अज्ञात', 'माध्व सम्प्रदाय', 'वल्लभ सम्प्रदाय', 'निम्बार्क सम्प्रदाय', 'रामानंदी संप्रदाय', 'रसिक संप्रदाय']
sampradaya_list.each do | sampradaya |
  Sampradaya.create!(name: sampradaya) if Sampradaya.where(name: sampradaya).blank?
end

author_list = ['हित हरिवंश', 'स्वामी श्री हरिदास', 'हरिराम व्यास', 'सूरदास', 'कुम्भनदास', 'चतुर्भुजदास', 'छीतस्वामी',
  'गोविंदस्वामी', 'कृष्णदास', 'नंददास', 'परमानन्ददास', 'अज्ञात']
author_list.each do | author |
  Author.create!(name: author, is_approved: true, is_saint: true, user_id: 1) if Author.where(name: author).blank?
end

# ScriptureType.create!(name: "वेद") if ScriptureType.where(name: "वेद").blank?
# ScriptureType.create!(name: "पुराण") if ScriptureType.where(name: "पुराण").blank?
# ScriptureType.create!(name: "उपनिषद") if ScriptureType.where(name: "उपनिषद").blank?
# ScriptureType.create!(name: "स्मृति") if ScriptureType.where(name: "स्मृति").blank?
# ScriptureType.create!(name: "श्रुतियाँ") if ScriptureType.where(name: "श्रुतियाँ").blank?
# ScriptureType.create!(name: "नीति") if ScriptureType.where(name: "नीति").blank?
# ScriptureType.create!(name: "शास्त्र") if ScriptureType.where(name: "शास्त्र").blank?
# ScriptureType.create!(name: "दर्शन") if ScriptureType.where(name: "दर्शन").blank?
scripture_type_list = ["ग्रन्थ", "रसिक वाणी", "कथायें", "प्रचलित संकलन", "नवीन संकलन"]
scripture_type_list.each do | scripture_type |
  ScriptureType.create!(name: scripture_type) if ScriptureType.where(name: scripture_type).blank?
end

# ScriptureType.create!(name: "अष्टयाम") if ScriptureType.where(name: "अष्टयाम").blank?
StrotaType.create!(name: "आरती") if StrotaType.where(name: "आरती").blank?
StrotaType.create!(name: "चालीसा") if StrotaType.where(name: "चालीसा").blank?
StrotaType.create!(name: "शतक") if StrotaType.where(name: "शतक").blank?

StrotaType.create!(name: "स्त्रोत") if StrotaType.where(name: "स्त्रोत").blank?
StrotaType.create!(name: "अन्य") if StrotaType.where(name: "अन्य").blank?

context_list = ["अन्य", "वन विहार", "श्रृंगार", "शरद ऋतु", "वर्षा ऋतु", "नौका विहार", "होली", "व्याहुला", "झूलन उत्सव", 
  "जन्म उत्सव", "फूल बंगला उत्सव", "खिचड़ी उत्सव", "शीत ऋतू", "दान लीला", "रास लीला", "जनकलली जमनोत्सव", 
  "वृषभानुलली जमनोत्सव", "श्रीकृष्ण जन्मोत्सव", "श्रीकृष्ण जन्मोत्सव"]

context_list.each do | context |
  User.first.contexts.create!(name: context) if Context.where(name: context).blank?
end

raag_list = [{name: 'मल्हार', name_eng: 'malhar'}, {name:'विहाग', name_eng:'vihag'}, {name:'पूरवी', name_eng:'vihag'}, 
  {name:'भैरव', name_eng: 'bhairav'}, {name:'आसावरी', name_eng: 'asawari'}, {name: 'कमोद', name_eng:'kamod'}, 
  {name: 'टोडी', name_eng: 'todi'}, {name:'धनाश्री', name_eng: 'dhanashri'}, {name:'सोरठ', name_eng:'sorath'}, 
  {name:'रामकली', name_eng:'ramkali'}, {name:'विभास', name_eng:'vibhas'}, {name:'गौड़', name_eng: 'gound'},
  {name:'जयजयवन्ती', name_eng: 'jayjayvanti'}, {name:'कालिंगडा', name_eng:'kalinga'}, {name:'बसंत', name_eng:'basanti'}, 
  {name:'देवगंधार', name_eng:'devgandhar'}, {name:'सारंग', name_eng:'sarang'}, {name:'कल्याण', name_eng: 'kalyan'}, 
  {name: 'मारू', name_eng: 'maru'}, {name:'गौरी', name_eng: 'gouri'}, {name:'भूपाली', name_eng: 'bhupali'}, 
  {name: 'हमीर', name_eng: 'hamir'}, {name:'देश', name_eng: 'desh'}, {name:'बिलावल', name_eng:'bilawal'},
  {name: 'काफ़ी', name_eng:'kafi'}, {name: 'नायकी', name_eng: 'nayaki'}, {name:'मालकौंस', name_eng:'maalkons'}, 
  {name: 'अडानो', name_eng: 'adano'}, {name:'परज', name_eng:'paraj'}, {name:'सिंधुरा', name_eng:'sindhura'}, 
  {name: 'तथा', name_eng: 'tatha'}, {name:'खमाज', name_eng:'khamaj'}, {name: 'पीलू', name_eng: 'pilu'}, 
  {name: 'झिंझोटी', name_eng: 'jhinjhoti'}, {name: 'अल्हैया', name_eng: 'alhaiya'}, {name: 'ललित', name_eng: 'lalit'}, 
  {name: 'रायसो', name_eng: 'rayaso'}, {name:'मुल्तानी', name_eng: 'multani'}, {name:'जंगला', name_eng: 'jangala'}, 
  {name: 'हिंडोल', name_eng: 'hindol'}, {name:'भीमपलासी', name_eng: 'bheempalasi'}, {name:'कलावती', name_eng:'kalavati'}, 
  {name: 'श्री', name_eng: 'shri'}, {name:'कान्हरौ', name_eng: 'kanharo'}, {name:'षट', name_eng:'kshat'}, 
  {name: 'केदारौ', name_eng: 'kedaro'}, {name:'जिला', name_eng: 'jila'}, {name: 'नट', name_eng: 'nat'}, {name: 'शहानौ', name_eng: 'shahano'}];

raag_list.each do | raag |
  Raag.create!(raag) if Raag.where(raag).blank?
end
