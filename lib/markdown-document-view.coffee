{Point} = require('atom')
toc = require('markdown-toc')
read = require('fs')
remarkable = require('remarkable')

module.exports =
class MarkdownDocumentView

  constructor: (serializedState) ->

# Commented out editor returns first line!
    # editor = atom.workspace.getActiveTextEditor()
  #  for linenumber in [editor.getLastBufferRow()..0]
  #    linetext = editor.lineTextForBufferRow(linenumber)

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('md-document')
    # Create message element
    message = document.createElement('div')

    # Get editor
    editor = atom.workspace.getActiveTextEditor()
    filePath = editor.getPath()
    editorContent = ''
    outline = ''

    mdContent = (callback) ->
      read.readFile filePath, 'utf8',  (err, data) ->
        if err
          throw err
        editorContent = data
        callback editorContent
        return
      return

    mdOutline = ->
      outlinedata = toc(editorContent).json
      console.log outlinedata
      outlinedata.forEach (heading) ->
        if heading.lvl == 1
          outline += '- '
        if heading.lvl == 2
          outline += '\t* '
        if heading.lvl == 3
          outline += '\t\t+ '
        if heading.lvl == 4
          outline += '\t\t\t- '
        if heading.lvl == 5
          outline += '\t\t\t\t* '
        if heading.lvl == 6
          outline += '\t\t\t\t\t+ '
        outline += '[' + toc.linkify(heading.content) + ']'
        outline += '(' + toc.linkify(heading.lines[0]) + ')'
        outline += '\n'
        return
      console.log outline
      # Remove all child nodes from message.
      while message.hasChildNodes()
        message.removeChild message.firstChild
      outliner = document.createTextNode(outline)
      message.appendChild(outliner)
      return

    test = ''

    handleClick = ->
      console.log 'link clicked'
      position = new Point(7, 0)
      editor.setCursorBufferPosition(position)
      editor.scrollToBufferPosition(position, center: true)

    content = read.readFileSync filePath, 'utf8'
    outlinedata = toc(content).json
    outlinedata.forEach (heading) ->
      if heading.lvl == 1
        outline += '- '
      if heading.lvl == 2
        outline += '\t* '
      if heading.lvl == 3
        outline += '\t\t+ '
      if heading.lvl == 4
        outline += '\t\t\t- '
      if heading.lvl == 5
        outline += '\t\t\t\t* '
      if heading.lvl == 6
        outline += '\t\t\t\t\t+ '
      outline += '[' + toc.linkify(heading.content) + ']'
      outline += '(' + toc.linkify(heading.lines[0]) + ')'
      outline += '\n'
      return

    md = new remarkable()
    render = md.render(outline)

    # message.innerHTML = render
    outliner = document.createTextNode(outline)
    message.appendChild(outliner)
    a = document.createElement('a')
    linkText = document.createTextNode('link text')
    a.appendChild(linkText)
    a.id = 'myLink'
    a.addEventListener 'click', handleClick
    message.appendChild(a)
    message.classList.add('message')

    @element.appendChild(message)

    # This does change the filePath variable when the editor opens a new file. Does not refresh the existing markdown toc!
    # test does append the word testing to the existing modal. Needs to check if the modal contains the outline element. If true, remove. Then recreate!
    atom.workspace.observeTextEditors (editor) ->
      filePath = editor.getPath()
      outline = ''
      mdContent mdOutline
      test = document.createTextNode(' testing ')
      message.appendChild(test)



  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
