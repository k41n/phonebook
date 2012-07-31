Person.delete_all
PhoneNumber.delete_all

def add_record(name,number)
  p = Person.create(name: name)
  p.phone_numbers.create(number: number)
end

add_record('D.Chelimsky','+79272717777')
add_record('A.Hellesoy','+79021234567')
add_record('D.H. Hansson','+79061231231')
add_record('Y.Matsumoto','+72760987654')


