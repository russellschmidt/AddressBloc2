require_relative 'entry'
require "csv"
require "bloc_record/base"

class AddressBook < BlocRecord::Base

  def add_entry(name, phone_number, email)
    Entry.create(address_book_id: self.id, name: name, phone_number: phone_number, email: email)
  end

  def entries
    # returns all the entries
    Entry.where(address_book_id: self.id)
  end

  def entries_by_name_asc
    Entry.order(name: :ASC)
  end

  def entries_by_name_desc
    Entry.order(name: :DESC)
  end

  def entries_by_phone_asc
    Entry.order(phone_number: :ASC)
  end

  def entries_by_phone_desc
    Entry.order(phone_number: :DESC)
  end

  def entries_by_email_asc
    Entry.order(email: :ASC)
  end

  def entries_by_email_desc
    Entry.order(email: :DESC)
  end

  def find_entry(name)
    # returns the first name match
    Entry.where(name: name, address_book_id: self.id).first
  end

  def find_entry_by_id(id)
    Entry.where(id: id, address_book_id: self.id).first
  end

  def import_from_csv(file_name)
    # Implementation goes here
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end

end
