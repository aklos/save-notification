{CompositeDisposable} = require 'atom'

module.exports = SaveNotification =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'core:save': => @notify()

  deactivate: ->
    @subscriptions.dispose()

  notify: ->
    editor = atom.workspace.getActivePaneItem()
    if editor.isModified()
        atom.notifications.addSuccess('Saved.')
        file = editor?.buffer.file
        filePath = file?.path
        atom.notifications.addInfo(filePath)
    else
        atom.notifications.addInfo('No modifications to save.')
