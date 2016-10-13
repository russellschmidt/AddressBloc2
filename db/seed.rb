require_relative '../models/address_book'
require_relative '../models/entry'
require 'bloc_record'

BlocRecord.connect_to('db/address_bloc.sqlite')

book = AddressBook.create(name: 'My Address Book')

puts 'Address Book created'
puts 'Entry created'
puts Entry.create(address_book_id: book.id, name: 'Foolio Coolio', phone_number: '201-555-1111', email: 'FoolioCoolio@aol.com' )
puts Entry.create(address_book_id: book.id, name: 'Jambalaya Scrapple', phone_number: '202-555-3333', email: 'JambalayaScrapple@aol.com' )
puts Entry.create(address_book_id: book.id, name: 'Dirt McGirt', phone_number: '718-555-6666', email: 'OsirisBigBabyJesus@wutang.com' )