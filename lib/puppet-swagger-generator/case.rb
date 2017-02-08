class String
  def swagger_to_snake_case
    self.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
  end

  def swagger_to_camel_back
    self.split('_').inject([]){ |b,e| b.push(b.empty? ? e : e.capitalize) }.join
  end
end