require_relative '../models/address_book'

class MenuController
  attr_accessor :address_book

  def initialize
    @address_book = AddressBook.first
  end

  def main_menu
    puts "#{@address_book.name} Address Book Selected\n#{@address_book.entries.count} entries"
    puts "0 - Switch AddressBook"
    puts "1 - View all entries"
    puts "2 - Create an entry"
    puts "3 - Search for an entry"
    puts "4 - Import entries from a CSV"
    puts "5 - Exit"

    print "Enter your selection: "

    selection = gets.to_i

    case selection
      when 0
        system "clear"
        select_address_book_menu
        main_menu
      when 1
        system "clear"
        view_all_entries
        main_menu
      when 2
        system "clear"
        create_entry
        main_menu
      when 3
        system "clear"
        search_entries
        main_menu
      when 4
        system "clear"
        read_csv
        main_menu
      when 5
        puts "Good-bye!"
        exit(0)
      else
        system "clear"
        puts "Sorry, that is not a valid input"
        main_menu
    end
  end


  def select_address_book_menu
    puts "Select an Address Book:"
    AddressBook.all.each_with_index do |address_book, index|
      puts "#{index + 1} - #{address_book.name}"
    end

    index = gets.chomp.to_i
    
    @address_book = AddressBook.find(index)
    system "clear" 

    return if @address_book
    puts "Please select a valid index"
    select_address_book_menu

  end


  def view_all_entries
    puts "How would you like your chicken mcdeath?"
    puts "1 - Not ordered"
    puts "2 - Ascending order by name"
    puts "3 - Descending order by name"
    puts "4 - Ascending order by phone number"
    puts "5 - Descending order by phone number"
    puts "6 - Ascending order by email"
    puts "7 - Descending order by email"

    selection = gets.to_i

    case selection
    when 1
      @address_book.entries.each do |entry|
        system "clear"
        puts entry.to_s
        entry_submenu(entry)
      end
    when 2
      @address_book.entries_by_name_asc.each do |entry|
        system "clear"
        puts entry.to_s
        entry_submenu(entry)
      end
    when 3
      @address_book.entries_by_name_desc.each do |entry|
        system "clear"
        puts entry.to_s
        entry_submenu(entry)
      end
    when 4
      @address_book.entries_by_phone_asc.each do |entry|
        system "clear"
        puts entry.to_s
        entry_submenu(entry)
      end
    when 5
      @address_book.entries_by_phone_desc.each do |entry|
        system "clear"
        puts entry.to_s
        entry_submenu(entry)
      end
    when 6
      @address_book.entries_by_email_asc.each do |entry|
        system "clear"
        puts entry.to_s
        entry_submenu(entry)
      end
    when 7  
      @address_book.entries_by_email_desc.each do |entry|
        system "clear"
        puts entry.to_s
        entry_submenu(entry)
      end
    when ''
      system "clear"
      main_menu
    else
      system "Invalid choice"
      view_all_entries
    end

    system "clear"
    puts "End of entries"
  end

  def create_entry
    system "clear"
    puts "New AddressBloc Entry"

    name = get_new_name
    phone_number = get_new_phone
    email = get_new_email

    # print "Name: "
    # name = gets.chomp
    # print "Phone number: "
    # phone = gets.chomp
    # print "Email: "
    # email = gets.chomp

    address_book.add_entry(name, phone_number, email)

    system "clear"
    puts "New entry created"
  end

  def search_entries
    print "Search by name: "
    name = gets.chomp
    match = @address_book.find_entry(name)
    system "clear"
    if match
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end

  def read_csv
    print "Enter CSV file to import: "
    file_name = gets.chomp

    if file_name.empty?
      system "clear"
      puts "No CSV file read"
      main_menu
    end

    begin
      entry_count = address_book.import_from_csv(file_name).count
      system "clear"
      puts "#{entry_count} new entries added from #{file_name}"
    rescue
      puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
      read_csv
    end
  end

  def entry_submenu(entry)
    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    selection = gets.chomp

    case selection
      when "n"
      when "d"
        delete_entry(entry)
      when "e"
        edit_entry(entry)
        entry_submenu(entry)
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        entry_submenu(entry)
    end
  end

  def delete_entry(entry)
    address_book.delete(entry)
    puts "#{entry.name} has been deleted"
  end

  def edit_entry(entry)
    updates = {}

    print "Updated name: "
    name = gets.chomp
    updates[:name] = name unless name.empty?

    print "Updated phone number: "
    phone_number = gets.chomp
    updates[:phone_number] = phone_number unless phone_number.empty?

    print "Updated email: "
    email = gets.chomp

    updates[:email] = email unless email.empty?

    entry.update_attributes(updates)

    system "clear"
    puts "Updated entry: "

    puts Entry.find(entry.id)
  end

  def search_submenu(entry)
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"
    selection = gets.chomp

    case selection
      when "d"
        system "clear"
        delete_entry(entry)
        main_menu
      when "e"
        edit_entry(entry)
        system "clear"
        main_menu
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        puts entry.to_s
        search_submenu(entry)
    end
  end

  def get_new_name
    name_ok = false
    name = 'Bob McRoberts'

    until (name_ok)
      print "Name ('firstname lastname'): "
      name = gets.chomp
      if name == ""
        puts "Please enter a name."
        name_ok = false
      elsif name.length < 2
        puts "Please enter a valid name of more than one character"
      elsif name.match(/\A[^0-9`!@#\$%\^&*+_=]+\z/) != nil
        name_ok = true
      else
        puts "Please enter a name using valid characters."
      end
    end
    name
  end


  def get_updated_name
    name_ok = false
    name = 'Bob McRoberts'

    until (name_ok)
      print "Name ('firstname lastname'): "
      name = gets.chomp
      if name.match(/\A[^0-9`!@#\$%\^&*+_=]+\z/) != nil || name.empty?
        name_ok = true
      elsif name.length < 2
        puts "Please enter a valid name of more than one character"
      else
        puts "Please enter a name using valid characters"
      end
    end
    name
  end

  def get_new_phone
    phone_ok = false
    phone = '212-555-1000'
    until (phone_ok)
      print "Phone number (example: 212-555-1000): "
      phone = gets.chomp
      # enforce 10 number 2 dash ###-###-#### format though ########### is ok
      # also #11 is reserved for emergency services
      if phone.match(/\d11-?\d{3}-?\d{4}/) != nil || phone.match(/\d{3}-?\d11-?\d{4}/) != nil
        puts "#{phone} does not seem like a valid number. Be sure to use ###-###-#### format. Please try again."
      # N.Am. area codes cant start with 0, 1. CO code can't start with 0, 1.
      elsif phone.index(/[2-9]\d{2}-?[2-9]\d{2}-?\d{4}/) == 0
        phone_ok = true
      else
        puts "Must be in XXX-XXX-XXXX format"
      end
    end
    phone
  end


  def get_updated_phone
    phone_ok = false
    phone = '212-555-1000'
    until (phone_ok)
      print "Updated phone number (example: 212-555-1000): "
      phone = gets.chomp
      # enforce 10 number 2 dash ###-###-#### format though ########### is ok
      # also #11 is reserved for emergency services
      if phone.match(/\d11-?\d{3}-?\d{4}/) != nil || phone.match(/\d{3}-?\d11-?\d{4}/) != nil
        puts "#{phone} does not seem like a valid number. Please try again."
      # N.Am. area codes cant start with 0, 1. CO code can't start with 0, 1.
      elsif phone.index(/[2-9]\d{2}-?[2-9]\d{2}-?\d{4}/) == 0
        phone_ok = true
      elsif phone.empty?
        phone_ok = true
      else
        puts "Must be in XXX-XXX-XXXX format"
      end
    end
    phone
  end

  def get_new_email
    email_ok = false
    email = 'boberts@example.com'
    
    until (email_ok)
      print "Email: "
      email = gets.chomp
      # Regex found online. Just letters, numbers, underscore, dash and dot in the username.
      if email.match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i) != nil
        email_ok = true
      else
        puts "Please enter a valid email in username@domain.tld format"
      end
    end
    email
  end


  def get_updated_email
    email_ok = false
    email = 'boberts@example.com'

    until (email_ok)
      print "Updated email: "
      email = gets.chomp
      if email.match(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i) != nil
        email_ok = true
      elsif email.empty? 
        email_ok = true
      else
        puts "Please enter a valid email in username@domain.topleveldomain format"
      end
    end
    email
  end

end