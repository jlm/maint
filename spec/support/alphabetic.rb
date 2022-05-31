# Generate an alphabetic string of a given length
def generate_text(number)
  charset = Array("A".."Z") + Array("a".."z")
  Array.new(number) { charset.sample }.join
end
