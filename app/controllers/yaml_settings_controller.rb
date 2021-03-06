class YamlSettingsController < ApplicationController
  include ClassLogger

  def reload
    authorize(current_user, :can_reload_yaml_settings?)
    begin
      # Feature flag diff is our litmus test: Were settings actually reloaded?
      feature_flags_before = Settings.features.marshal_dump

      Rails.logger.warn 'Reloading application settings from YAML in web subsystem'
      CalcentralConfig.reload_settings
      Rails.logger.warn 'YAML settings reloaded. Ask yourself, should I clear the cache?'

      Rails.logger.warn 'Requesting message processors across cluster to reload application settings'
      SettingsReloadWorker.request_reload

      feature_flags_after = Settings.features.marshal_dump
      msg = (feature_flags_before.to_a - feature_flags_after.to_a).any? ?
        'Settings reloaded. Please consider clearing the cache.' :
        'Warning: No change detected in feature flags. Please verify that your settings were loaded.'
      # Give user a snippet of the settings for the sake of his/her own verification
      json = {
        message: msg,
        snippet: {
          features: feature_flags_after
        }
      }
      response_code = 200
    rescue => e
      logger.fatal msg = %Q(Failed to reload YAML file. PLEASE consider a server restart because the state of the system is unknown.
#{e.message}
#{e.backtrace.join "\n\t"})
      json = { message: msg }
      response_code = 500
    end
    render :json => json, :status => response_code
  end

end
