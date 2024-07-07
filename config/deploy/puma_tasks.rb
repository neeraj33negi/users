def create_puma_systemd_file
  template_path = File.expand_path("../templates/puma.service.erb",File.dirname(__FILE__))
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), "/tmp/puma.service", mode: 0644
  execute "sudo mv /tmp/puma.service /etc/systemd/system/"
end

def reload_systemd
  execute "sudo systemctl daemon-reload"
end

def reload_puma
  execute "sudo systemctl reload puma.service"
end

def start_puma
  execute "sudo systemctl start puma.service"
end

def copy_puma_file
  execute "sudo cp ../puma.rb #{shared_path}/puma.rb"
end

namespace :deploy do
  namespace :puma do
    desc "Deploy puma systemd"
    task :service do
      on roles("puma-app"), in: :sequence do |host|
        if test("[ -f /etc/systemd/system/puma.service ]")
          puts "[#{host}] Puma service file already exists. Reloading app"

          # This line gives us a room to push changes to puma systemd file. Incase these changes require
          # systemd srestart to take effect, we'd need to do that separately.
          create_puma_systemd_file
          reload_systemd
          reload_puma
        else
          puts "[#{host}] Puma service file not found. Creating a systemd file "
          create_puma_systemd_file
          start_puma
        end

        sleep(20)
        # Status command returns a NZEC if the service failed to start, hence failing the deploy!
        execute "sudo systemctl status puma.service"
      end
    end

    task :config do
      on roles("puma-app"), in: :sequence do |host|
        if test("[ -f #{shared_path}/puma.rb ]")
          puts "[#{host}] Skipping #{shared_path}/puma.rb as it already exists"
        else
          template_path = File.expand_path("../templates/puma.rb.erb", File.dirname(__FILE__))
          template = ERB.new(File.new(template_path).read).result(binding)
          upload! StringIO.new(template), "#{shared_path}/puma.rb", mode: 0644
        end
      end
    end
  end

  # after "deploy:generate_config_from_secrets", "deploy:puma:config"
  # after "deploy:symlink:release", "deploy:puma:service"
end
