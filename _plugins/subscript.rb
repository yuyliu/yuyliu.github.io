module Jekyll
  class Scholar
    class Subscript < BibTeX::Filter
      def apply(value)
        value.to_s.gsub(/\\textsubscript(\{(?:[^{}]|\g<1>)*\})/) {
          "<sub>#{$1[1..-2]}</sub>"
        }
      end
    end
  end
end
