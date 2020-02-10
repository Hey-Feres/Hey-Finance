class Transaction < ApplicationRecord
  
  def self.to_csv
    attributes = %w{kind title value group created_at}
    
    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

end
