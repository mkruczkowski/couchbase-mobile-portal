class StripingTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
    @input = input
  end

  def render(context)
  	input_split = split_params(@input)
  	swift = input_split[0].strip
  	objc = input_split[1].strip
  	c = input_split[2].strip
  	java = input_split[3].strip
  	
    output = "<block class=\"swift inline\"><code> #{swift}</code></block>"
    output += "<block class=\"objc inline\"><code> #{objc}</code></block>"
    output += "<block class=\"net inline\"><code> #{c}</code></block>"
    output += "<block class=\"java inline\"><code> #{java}</code></block>"
    return output
  end
  
  def split_params(params)
  	params.split("|")
  end
end

Liquid::Template.register_tag('st', StripingTag)