# -*- encoding : utf-8 -*-
class MultiWorkersProcessMaster
  @queue = :low
  MAX = 10

  def self.perform clazz
    master = clazz.constantize.new

    if master.already_started?

      if master.has_finished?
        master.join
        elapsed_time = master.finish
        puts "finalizou em #{elapsed_time}s"
        # notifica tech
        DevAlertMailer.notify({to: 'tech@olook.com.br', 
          subject: "Geracao da base para AllIn concluida (em #{elapsed_time}s)"}).deliver!
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