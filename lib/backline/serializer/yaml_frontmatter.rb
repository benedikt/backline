module Backline
  module Serializer
    module YAMLFrontmatter
      def self.dump(data)
        frontmatter = data.dup
        content = frontmatter.delete('content')

        Backline::Serializer::YAML.dump(frontmatter) + "---\n" + content
      end

      def self.load(data)
        return unless match = data.match(/^---\n(?<frontmatter>.*)\n---\n(?<content>.*)/m)

        attributes = Backline::Serializer::YAML.load(match[:frontmatter])
        attributes['content'] = match[:content]
        attributes
      end
    end
  end
end
