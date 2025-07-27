class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy rescan ]

  def index
    search_params = params.permit(:field, :term).to_h.symbolize_keys
    @profiles = Profile.search(**search_params).order(created_at: :desc).limit(10)
  end

  def show
  end

  def new
    @profile = Profile.new
  end

  def edit
    @from = params[:from] || 'show'
  end

  def create
    @profile = Profile.new(profile_params)
    return render_create_failure unless @profile.valid?(:user_input)

    scraper_result = Github::ProfileScraper.call(@profile.github_url)

    unless scraper_result.success?
      @alert_message = t(scraper_result.error, scope: 'profiles.errors')
      return render_create_failure
    end

    @profile.assign_attributes(scraper_result.data)
    @profile.save ? render(:create) : render_create_failure
  end

  def rescan
    scraper_result = Github::ProfileScraper.call(@profile.github_url)

    unless scraper_result.success?
      flash.now[:alert] = t(scraper_result.error, scope: 'profiles.errors')
      return render turbo_stream: turbo_stream.replace('flash', partial: 'shared/flash')
    end

    if @profile.update(scraper_result.data.symbolize_keys)
      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = t('.failure')
    end

    render :rescan, formats: :turbo_stream
  end

  def update
    if @profile.update(profile_params)
      redirect_to @profile, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @profile.destroy!

    respond_to do |format|
      format.html { redirect_to profiles_path, status: :see_other, notice: t('.success') }
    end
  end

  private

  def set_profile
    @profile = Profile.find(params.expect(:id))
  end

  def profile_params
    params.expect(profile: [ :name, :github_url, :field, :term ])
  end

  def render_create_failure
    render :create_failure, status: :unprocessable_entity
  end
end
