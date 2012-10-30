require "./parser.rb"

file_name = ""
ARGV.each do |p|
  file_name += p + " "
end

parser = Parser.new
parser.get_series(file_name)
