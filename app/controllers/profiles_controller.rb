class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]

  def index
    @profiles = Profile.all
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

    scraper_result = Github::ProfileScraper.call(@profile.github_url)

    unless scraper_result.success?
      flash.now[:alert] = t(scraper_result.error, scope: 'profiles.errors')
      return render :new, status: :unprocessable_entity
    end

    @profile.assign_attributes(scraper_result.data)

    if @profile.save
      flash.now[:notice] = t('.success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def rescan
    @profile = Profile.find(params[:id])

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
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to @profile, notice: t('.success') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
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
    params.expect(profile: [ :name, :github_url ])
  end
end
