class Fdoc::SamplePresenter < Fdoc::BasePresenter
  
  def initialize(schema, options)
    super(options)
    @schema = schema
  end
  
  def to_html
    
    html = StringIO.new

    html << '<div class="schema">'
    html << render_markdown(@schema["description"])
    
    html << '<ul>'
    begin
      @schema.each do |key, properties|
        
        html << '<li>'
        html << tag_with_anchor(
          'span',
          '<tt>%s</tt>' % key
        )
        
        if properties["description"]        
          html << '<div class="schema">'
            html << '<p>' + properties["description"] + '</p>'
          html << '</div>'
        end
        
        properties["values"].each do |value|
          html << '<div class="schema">'
          html << '<ul>'
            html << '<li>'
              html << tag_with_anchor(
                'span',
                '<tt>%s</tt>' % value["value"]
              )
            html << '</li>'
            html << render_markdown(value["result"])
          html << '</ul>'
          html << '</div>'
        end
        
        html << '</li>'
        
      end
    end

    html << '</ul>'
    html << '</div>'

    html.string
    
    
  end
  
end