RailsAdmin.config do |config|

  config.main_app_name = [ENV["COMMITTEE"], "Maintenance Database"]

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    import                        # for rails_admin_import

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  # Options for rails_admin_import:
  config.configure_with(:import) do |config|
    config.update_if_exists = true      # set the "update if exists" checkbox by default.
  end

  config.model 'Project' do
    import do
      mapping_key :designation
    end
    export do
      field :designation
      field :project_type
      field :short_title
      field :last_motion
      field :status
      field :draft_no
      field :next_action
      field :task_group
      field :files_url
      field :par_url
      field :csd_url
    end
  end

  config.model 'TaskGroup' do
    import do
      mapping_key :abbrev
    end
    export do
      field :abbrev
      field :name
    end
  end
end
