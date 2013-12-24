DB = Sequel.connect('sqlite://rabbits.db')

class Rabbit < Sequel::Model
end