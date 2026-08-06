require "bibtex"

module BibTeX
  module Filters
    class Typography < Filter
      COMMANDS = {
        "\\emph" => ["<em>", "</em>"],
        "\\textbf" => ["<b>", "</b>"],
        "\\textit" => ["<i>", "</i>"],
        "\\textsubscript" => ["<sub>", "</sub>"],
        "\\textsuperscript" => ["<sup>", "</sup>"],
        "\\texttt" => ["<code>", "</code>"],
        "\\underline" => ["<u>", "</u>"],
      }.freeze

      def apply(value)
        convert(value.to_s)
      end

      private

      def convert(text)
        output = +""
        index = 0

        while index < text.length
          command = command_at(text, index)

          if command
            opening_brace = skip_whitespace(
              text,
              index + command.length
            )

            if text[opening_brace, 1] == "{"
              content, closing_brace = extract_group(
                text,
                opening_brace
              )

              if closing_brace
                opening_tag, closing_tag = COMMANDS.fetch(command)

                output << opening_tag
                output << convert(content)
                output << closing_tag

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

      def command_at(text, index)
        COMMANDS.keys.find do |command|
          text[index, command.length] == command &&
            command_boundary?(text, index + command.length)
        end
      end

      def command_boundary?(text, index)
        next_character = text[index, 1]

        next_character.nil? ||
          next_character.empty? ||
          next_character.match?(/[\s{]/)
      end

      def skip_whitespace(text, index)
        while index < text.length &&
              text[index, 1].match?(/\s/)
          index += 1
        end

        index
      end

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
              content = text[content_start...index]
              return [content, index]
            end
          end

          index += 1
        end

        [nil, nil]
      end
    end
  end
end