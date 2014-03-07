# -*- encoding : utf-8 -*-
class MultiWorkersProcessMaster
  @queue = :low
  MAX = 10

  def self.perform clazz
    master = clazz.constantize.new

    if master.already_started?

      if master.has_finished?
        master.join
        
      else
        master.sleep
      end

    else
      master.start
      master.split
      master.sleep
    end
   
  end

end