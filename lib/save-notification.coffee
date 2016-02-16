{CompositeDisposable} = require 'atom'

module.exports = SaveNotification =
  subscriptions: null
  changedPanes: []

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    # @subscriptions.add atom.commands.add 'atom-workspace', 'pane:active-item-changed': => @changed()
    @subscriptions.add atom.commands.add 'atom-workspace', 'core:save': => @notify()

  deactivate: ->
    @subscriptions.dispose()
    @changedPanes.dispose()

  changed: ->
    editor = atom.workspace.getActivePaneItem()
    if editor not in @changedPanes
        @changedPanes.push editor

    console.log @changedPanes

  notify: ->
    editor = atom.workspace.getActivePaneItem()
    # if editor in @changedPanes
    atom.notifications.addSuccess('File saved.')
    file = editor?.buffer.file
    filePath = file?.path
    atom.notifications.addInfo(filePath)
    #     @changedPanes.splice(@changedPanes.indexOf(editor), 1)
