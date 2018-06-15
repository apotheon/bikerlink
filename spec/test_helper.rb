def a_to_s object, methods
  methods.map {|m| object.send(m.to_sym).to_s }.join ' '
end
