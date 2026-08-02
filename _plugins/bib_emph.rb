require "bibtex"

module BibTeX
  module Filters
    class Emph < Filter
      COMMAND = "\\emph"

      def apply(value)
        text = value.to_s
        output = +""
        index = 0

        while index < text.length
          if text[index, COMMAND.length] == COMMAND
            opening_brace = index + COMMAND.length

            while opening_brace < text.length &&
                  text[opening_brace, 1].match?(/\s/)
              opening_brace += 1
            end

            if text[opening_brace, 1] == "{"
              content, closing_brace = extract_group(text, opening_brace)

              if closing_brace
                output << "<em>#{content}</em>"
                index = closing_brace + 1
                next
              end
            end
          end

          output << text[index, 1]
          index += 1
        end

        output
      end

      private

      def extract_group(text, opening_brace)
        depth = 0
        content_start = opening_brace + 1
        index = opening_brace

        while index < text.length
          case text[index, 1]
          when "{"
            depth += 1
          when "}"
            depth -= 1

            if depth.zero?
              return [text[content_start...index], index]
            end
          end

          index += 1
        end

        [nil, nil]
      end
    end
  end
end
