{CompositeDisposable} = require 'atom'

module.exports = SaveNotification =
  config:
      enableSavedNotification:
          type: 'boolean'
          default: true
      enableInfoNotification:
          type: 'boolean'
          default: true
      enableNoChangeNotification:
          type: 'boolean'
          default: true
      notificationDuration:
          type: 'integer'
          default: 2000
          minimum: 100
          maximum: 10000
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
    n1 = null;
    n2 = null;
    n3 = null;
    if editor.isModified()
        if atom.config.get('save-notification.enableSavedNotification')
            n1 = atom.notifications.addSuccess('Saved.', { dismissable: true })
        if atom.config.get('save-notification.enableInfoNotification')
            file = editor?.buffer.file
            filePath = file?.path
            n2 = atom.notifications.addInfo(filePath, { dismissable: true })
    else if atom.config.get('save-notification.enableNoChangeNotification')
        n3 = atom.notifications.addInfo('No modifications to save.', { dismissable: true })
    setTimeout ( ->
        if n1
            n1.dismiss()
        if n2
            n2.dismiss()
        if n3
            n3.dismiss()
    ), atom.config.get('save-notification.notificationDuration')
