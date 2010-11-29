# == Schema Information
# Schema version: 20090930170613
#
# Table name: faqs
#
#  id         :integer(4)      not null, primary key
#  question   :string(255)     not null
#  user_id    :integer(4)      not null
#  answer     :text            default(""), not null
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Faq < ActiveRecord::Base
end
