 def get_state

 end

class DisplayState
    def self.get_state(display)
      d = Display.find_by_unique_id(display.unique_id)
      display = { id: d.unique_id, name: d.name }
      apps = d.apps
      staged_app = d.staged_app
      notes = d.notes.last(4).reverse
      setup = d.setup
      @state = { display: display, apps: apps, staged_app: staged_app, notes: notes, setup: setup }      
      return @state

    end
end

