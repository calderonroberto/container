 def get_state

 end


class DisplayState
    def self.get_state(display_id)

      d = Display.find_by_id(display_id)
      display = { id: d.id, name: d.name }
      apps = d.apps
      staged_app = d.staged_app
      messages = d.messages.last(4).reverse
      @state = { display: display, apps: apps, staged_app: staged_app, messages: messages }
      
      return @state

    end
end

