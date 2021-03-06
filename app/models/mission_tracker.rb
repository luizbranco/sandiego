module MissionTracker

  def create_mission_tracks
    @cities = City.all.map(&:id)
    @locations = Location.all.map(&:id)
    @traits = suspect.traits.map(&:id)
    @correct_fillers = Filler.correct_ones.map(&:id)
    @wrong_fillers = Filler.wrong_ones.map(&:id)
    level = rank.track_depth
    while level > 0
      create_correct_track(city, level)
      rank.track_breadth.times do
        create_wrong_track(city, level)
      end
      level -= 1
    end
    create_first_track(city)
  end

  private

  def city
    @cities.slice!(rand(@cities.length - 1))
  end

  def location
    @locations.slice!(rand(@locations.length - 1))
  end

  def trait
    @traits.slice!(rand(@traits.length - 1))
  end

  def correct_filler
    @correct_fillers.sample
  end

  def wrong_filler
    @wrong_fillers.sample
  end

  def create_first_track(city)
    track = self.tracks.create(:city_id => city, :level => 0, :correct => true, :final => false)
    create_network_information(track, city)
  end

  def create_correct_track(city, level)
    if level == rank.track_depth # Last track
      track = self.tracks.create(:city_id => city, :level => level, :correct => true, :final => true)
      create_network_final_information(track)
      @correct_city = city
    else
      track = self.tracks.create(:city_id => city, :level => level, :correct => true, :final => false)
      create_network_information(track, city)
      @correct_city = city
    end
  end

  def create_wrong_track(city, level)
    track = self.tracks.create(:city_id => city, :level => level, :correct => false, :final => false)
    create_network_wrong_information(track)
  end

  def create_network_information(track, city)
    create_suspect_information(track)
    clues = Clue.where(:city_id => @correct_city).map(&:id)
    2.times do
      clue = clues.slice!(rand(clues.length - 1))
      create_city_information(track, clue)
    end
  end

  def create_suspect_information(track)
    track.networks.create(:location_id => location, :informable_id => trait, :informable_type => 'Trait', :final => false)
  end

  def create_city_information(track, clue)
    track.networks.create(:location_id => location, :informable_id => clue, :informable_type => 'Clue', :final => false)
  end

  def create_network_final_information(track)
    create_final_filler_information(track)
    2.times do
      create_correct_filler_information(track)
    end
  end

  def create_final_filler_information(track)
    track.networks.create(:location_id => location, :informable_id => correct_filler, :informable_type => 'Filler', :final => true)
  end

  def create_correct_filler_information(track)
    track.networks.create(:location_id => location, :informable_id => correct_filler, :informable_type => 'Filler', :final => false)
  end

  def create_network_wrong_information(track)
    3.times do
      create_wrong_filler_information(track)
    end
  end

  def create_wrong_filler_information(track)
    track.networks.create(:location_id => location, :informable_id => wrong_filler, :informable_type => 'Filler', :final => false)
  end

end
