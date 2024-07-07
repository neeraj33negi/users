def upload_file(file)
  template_path = File.expand_path("../templates/#{file}.erb", File.dirname(__FILE__))
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), "#{shared_path}/config/#{file}", mode: 0644
end

def upload_config_files
  %w(secrets.yml database.yml).each do |file|
    upload_file(file)
  end
end

namespace :deploy do
  desc 'Generate yml files in shared directory'
  task :generate_config_from_secrets do
    on roles(:all), in: :sequence do |_host|
      upload_config_files
    end
  end

  before 'deploy:check:make_linked_dirs', 'deploy:generate_config_from_secrets'
end
