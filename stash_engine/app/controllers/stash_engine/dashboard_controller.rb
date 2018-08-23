require_dependency 'stash_engine/application_controller'

module StashEngine
  class DashboardController < ApplicationController
    before_action :require_login, only: [:show]

    def show
      current_user.terms_accepted_at = '2018-8-19' if params.key?(:accept_terms)
    end

    def metadata_basics; end

    def preparing_to_submit; end

    def upload_basics; end

    def migrate_data_mail
      current_user.old_dryad_email = params[:email]
      current_user.set_migration_token
      current_user.save
      StashEngine::MigrationMailer.migration_email(email: current_user.old_dryad_email,
                                                   code: current_user.migration_token,
                                                   url: auth_migrate_code_url).deliver_now
    end

    def migrate_data
      return unless User.find_by_migration_token(params[:code])
      return unless User.find_by_migration_token(params[:code]).id == current_user.id
      render 'stash_engine/dashboard/migrate_successful'
    end

    def migrate_successful; end

    # an AJAX wait to allow in-progress items to complete before continuing.
    def ajax_wait
      respond_to do |format|
        format.js do
          sleep 0.1
          head :ok, content_type: 'application/javascript'
        end
      end
    end
  end
end
