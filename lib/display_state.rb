 def get_state

 end

class DisplayState
    def self.get_state(display)
      d = Display.find_by_unique_id(display.unique_id)
      i = Log.where("(controller = ? OR controller = ? OR controller = ? OR controller = ?) AND display_id = ? AND created_at >= ?", 'mobile', 'notes', 'checkins', 'users', display.unique_id, DateTime.now - 5.minutes).last
      display = { id: d.unique_id, name: d.name }
      interaction = {interacting: (i.nil?) ? "false" : "true"}
      apps = d.apps
      staged_app = d.staged_app
      notes = d.notes.last(4).reverse
      setup = d.setup
      @state = { display: display, interaction: interaction, apps: apps, staged_app: staged_app, notes: notes, setup: setup }      
      return @state

    end
end

