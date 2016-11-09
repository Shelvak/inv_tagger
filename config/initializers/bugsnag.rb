Bugsnag.configure do |config|
  config.api_key = APP_CONFIG['bugsnag_key']
  config.notify_release_stages = %w(production staging)
  config.ignore_classes = []

  begin
    revision = if Rails.env.production?
                 File.read(Rails.root.join('REVISION')) # Capistrano Revision
               else
                 `git rev-parse --short HEAD`
               end.strip[0..6]

    version = "Ruby#{RUBY_VERSION}---#{revision}"

    config.app_version = version
  rescue
  end
end
