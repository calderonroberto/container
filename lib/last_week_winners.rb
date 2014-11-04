require 'logger'

class LastWeekWinners
    def self.get_winners(display)

      time_now = Time.zone.now
      time_beginning_of_week = Time.zone.now.beginning_of_week
      time_beginning_of_last_week = Time.zone.now.beginning_of_week-7.days
      last_week_winners = Array.new

      users = User.where('users.id != ?', '0').joins(:registrations).where('registrations.display_id' => display.unique_id)
    
      users.each do |user|
        #assemble last week winners hash
        last_week_user_hash = Hash.new
        last_week_user_hash["user"] = {id: user.id, name: user.name, thumbnail_url: user.thumbnail_url}
        last_week_user_hash["score"] = user.score(display, time_beginning_of_last_week, time_beginning_of_week)
        last_week_user_hash["score_from_date"] = time_beginning_of_last_week
        last_week_user_hash["score_to_date"] = time_beginning_of_week
        if last_week_user_hash["score"]["score"] > 0
           last_week_winners.push(last_week_user_hash)
        end
      end
      last_week_winners.sort_by! { |hash| -hash['score']['score'] }

      return last_week_winners.take(3)

    end
end

