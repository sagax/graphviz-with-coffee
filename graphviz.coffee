dotdoc = Object.create null
dotdoc.object = (name, options, style) ->
  self = @
  _object = Object.create null
  _object.name = name
  _object.relations_in = []
  _object.relations_out = []

  _object.options = options

  if style
    _object.style = style

  _object[">"] = (__object, __line) ->
    robject = Object.create null
    robject["object"] = __object
    if __line
      robject["line"] = __line

    _object.relations_in.push robject
    return

  _object["<"] = (__object, __line) ->
    robject = Object.create null
    robject["object"] = __object
    if __line
      robject["line"] = __line

    _object.relations_out.push robject
    return

  _object.clone = (_name, _label, with_relations) ->
    with_relations = with_relations or false
    __object = Object.assign {}, _object
    __object.name = _name

    if _label
      __object.options.label = _label

    unless with_relations
      __object.relations_in = []
      __object.relations_out = []

    self.dot.items.push __object
    __object

  @dot.items.push _object
  @dot.items_by_name[name] = _object
  _object

dotdoc.content = ""
dotdoc.endofline = "\n"
dotdoc.add = (line, number) ->
  space = ''
  if number and dotdoc.endofline is "\n"
    space = [0...number].reduce (a) ->
      return a + " "
    , ""
  @content += "#{space}#{line}#{@endofline}"
  return

dotdoc.addcl = (line, number) ->
  space = ''
  if number and @endofline is "\n"
    space = [0...number].reduce (a) ->
      return a + " "
    , ""
  @content += "#{space}#{line}"
  return

dotdoc.generator = (options) ->
  self = @
  options = options or Object.create(null)
  @add "digraph G {"

  ["node", "edge", "graph"].forEach (field) ->
    self.add "#{field} [", 2
    for key, value of self.dot[field]
      if typeof(value) is 'boolean'
        if value
          self.add "#{key} = \"true\";", 4
        else
          self.add "#{key} = \"false\";", 4

      else
        self.add "#{key} = \"#{value}\";", 4

    self.add "];", 2
    return

  @dot.items.forEach (item) ->
    self.add "\"#{item.name}\" [", 2

    if item.options
      if item.options.label
        if item.options.table
          self.addcl "label = \"#{item.options.label} | {", 4
          item.options.table.forEach (row) ->
            self.addcl ":#{row}\\l\n"
            return

          self.addcl "}\";"

        else
          self.add "label = \"#{item.options.label}\";", 4

    if item.style
      for key, value of item.style
        self.add "#{key} = \"#{value}\";", 4

    else
      for key, value of self.dot.defaultStyleItem
        self.add "#{key} = \"#{value}\";", 4

    self.add "];", 2

    item.relations_in.forEach (ritem) ->
      _item = ritem.object
      self.addcl "\"#{item.name}\" -> \"#{_item.name}\"", 2

      if ritem.line
        self.addcl "[", 1

        for key, value of ritem.line
          self.addcl "#{key} = #{value};", 1

        self.add "];"

      else
        if self.dot.defaultStyleLine
          self.addcl "[", 1
          for key, value of self.dot.defaultStyleLine
            self.addcl "#{key} = #{value};", 1

          self.add "];"
      return

    item.relations_out.forEach (ritem) ->
      _item = ritem.object
      self.addcl "\"#{_item.name}\" -> \"#{item.name}\"", 2

      if ritem.line
        self.addcl "[", 1

        for key, value of ritem.line
          self.addcl "#{key} = #{value};", 1

        self.add "];"

      else
        if self.dot.defaultStyleLine
          self.addcl "[", 1
          for key, value of self.dot.defaultStyleLine
            self.addcl "#{key} = #{value};", 1

          self.add "];"
      return
    return

  @add "}"
  return

dotdoc.print = ->
  console.log @content
  return

dotdoc.generator_and_print = ->
  @generator()
  @print()
  return

dotdoc.dot =
  items: []
  items_by_name: {}
  node:
    resolution: 200
    fontsize: 10
    fontname: "Free Mono Bold"
    fontcolor: "gray"
    color: "gray"
    shape: "record"
  edge:
    color: "gray"
    arrowtail: "odot"
    arrowhead: "vee"
    dir: "both"
    arrowsize: 0.3
    fontsize: 10
    fontname: "Free Mono Bold"
  graph:
    overlap: false
    splines: true
    bgcolor: "gray15"
    dpi: 120
    rankdir: "LR"
    pad: 1
  defaultStyleLine:
    color: "deepskyblue4"
    fontcolor: "white"
  defaultStyleItem:
    color: "deepskyblue4"
    fontcolor: "white"
    style: "filled"

dotdoc.object              = dotdoc.object.bind dotdoc
dotdoc.add                 = dotdoc.add.bind dotdoc
dotdoc.addcl               = dotdoc.addcl.bind dotdoc
dotdoc.generator           = dotdoc.generator.bind dotdoc
dotdoc.print               = dotdoc.print.bind dotdoc
dotdoc.generator_and_print = dotdoc.generator_and_print.bind dotdoc

module.exports = dotdoc
