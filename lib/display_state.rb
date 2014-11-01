 def get_state

 end

class DisplayState
    def self.get_state(display)
      d = Display.find_by_unique_id(display.unique_id)
      i = Log.where("(controller = ? OR controller = ? OR controller = ? OR controller = ? OR controller = ?) AND display_id = ? AND created_at >= ?", 'mobile', 'notes', 'checkins', 'users', 'sessions' , display.unique_id, DateTime.now - 5.minutes).last
      display = { id: d.unique_id, name: d.name}
      if (d.setup.interact_instructions)
        interaction = {interacting: (i.nil?) ? "false" : "true", instructions: "true"}
      else
        interaction = {instructions: "false"}
      end
      apps = d.apps
      staged_app = d.staged_app
      notes = d.notes.last(4).reverse
      #add user info. Done like this to allow back-compatibility with apps using this
      notes.each do |n| 
       u = User.find(n.from)
       user = Hash.new
       n["user_name"] = u.name
       n["user_thumbnail_url"] = u.thumbnail_url
      end
      setup = d.setup
      @state = { display: display, interaction: interaction, apps: apps, staged_app: staged_app, notes: notes, setup: setup }      
      return @state

    end
end

