module Jekyll
  class Scholar
    class Emphasis < BibTeX::Filter
      def apply(value)
        value.to_s.gsub(/\\emph(\{(?:[^{}]|\g<1>)*\})/) {
          "<em>#{$1[1..-2]}</em>"
        }
      end
    end
  end
end
