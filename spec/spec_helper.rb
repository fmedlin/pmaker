def contents_of_file(filename)
  File.open(filename).readlines
end

def include_match(s)
  simple_matcher("expression match") { |ary| ary.select { |e| e =~ s }.length > 0 }
end