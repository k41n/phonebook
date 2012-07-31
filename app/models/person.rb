class Person < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :phone_numbers

  def as_text
    "#{name}\t#{phone_numbers.collect{|y| y.number}.join("\t")}"
  end

  def self.as_text
    Person.all.collect{|x| x.as_text}.join("\n")
  end

  def self.sync_with(sync_text)
    @newborn, @updated, @deleted = sort_sync_lines(sync_text.split("\n"))
  end

private
  def self.sort_sync_lines(lines)
    persons = Person
    phone_numbers = PhoneNumber

    newborns = []
    updates = []
    deletions = []
    intact = []

    lines.each do |line|
      parts = line.split("\t")
      name = parts[0]
      phones = parts[1..-1]
      next if phones.empty? and not persons.exists?(name: name) #Damaged line

      if not persons.exists?(name: name)
        newborn = Person.create(name: name)
        phones.each do |phone|
          newborn.phone_numbers.create(number: phone)
        end
        newborns << newborn
      else
        to_update = Person.find_by_name(name)
        if to_update.phone_numbers.map(&:number) != phones
          to_update.phone_numbers.destroy_all
          phones.each do |phone|
            to_update.phone_numbers.create(number: phone)
          end
          updates << to_update
        else
          intact << to_update
        end
      end

    end
    unless newborns.empty? and updates.empty?
      deletions = (Person.all.map(&:id) - newborns.map(&:id) - updates.map(&:id) - intact.map(&:id)).collect{|x| Person.find(x)}
      deletions.each{|x| x.destroy}
    end

    [newborns,updates,deletions]
  end
end
