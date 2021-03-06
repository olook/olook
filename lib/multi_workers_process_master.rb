# -*- encoding : utf-8 -*-
class MultiWorkersProcessMaster
  @queue = 'low'

  def self.perform clazz, num_of_process=5
    master = clazz.constantize.new

    if master.already_started?

      if master.has_finished?
        master.join
        elapsed_time = master.finish
        # notifica tech
        DevAlertMailer.notify({to: 'tech@olook.com.br', 
          subject: "Geracao da base para AllIn concluida (em #{elapsed_time}s), com #{master.errors} erros", body: master.error_messages}).deliver!
      else
        master.sleep
      end

    else
      master.split(num_of_process)
      master.sleep
    end
  end
end
